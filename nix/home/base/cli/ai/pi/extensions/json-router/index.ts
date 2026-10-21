/**
 * JSON ドリブンなモデルルーター (Virtual Model)。
 *
 * `~/.pi/agent/router-rules.json` でカテゴリごとの振り分け先モデルと
 * thinking effort を管理し、Jev classifier にプロンプトのカテゴリ判定を
 * 任せて物理モデルへ振り分ける拡張機能。
 *
 * 使い方:
 *   pi --model router/auto
 *   または /model で "Auto (JSON Router)" を選択。
 *
 * ルール JSON のスキーマ (router-rules.json):
 * {
 *   "$schema": "./router-rules.schema.json",
 *   "classifier": { "model": "~typesafe/jev-latest" },   // 省略時の既定値
 *   "default": "deepseek/deepseek-v4.1-flash-1017",      // カテゴリ不定時の振り分け先
 *   "categories": {
 *     "complex-reasoning": { "model": "z-ai/glm-5.3", "thinkingLevel": "high" },
 *     "code-review":      { "model": "z-ai/glm-5.3", "thinkingLevel": "medium" },
 *     "implementation":   { "model": "deepseek/deepseek-v4.1-flash-1017", "thinkingLevel": "low" }
 *   }
 * }
 *
 * Jev classifier はカテゴリ名をそのまま criteria の選択肢として渡し、
 * ルール JSON に定義したカテゴリ名と突き合わせて振り分け先を解決する。
 * カテゴリ判定はセッション (branch) ごとに 1 回だけで、以降は state に保持する。
 */
import type { Message } from "@earendil-works/pi-ai";
import type {
	ExtensionAPI,
	ExtensionContext,
	ModelRoute,
	ModelRouteRequest,
} from "@earendil-works/pi-coding-agent";

// ルール JSON のパス (環境変数で上書き可)。
const RULES_PATH = process.env.PI_ROUTER_RULES ?? "~/.pi/agent/router-rules.json";

/** ルール JSON の1カテゴリ分の定義。 */
interface RuleCategory {
	model: string;
	thinkingLevel?: string;
}

/** ルール JSON 全体。 */
interface RouterRules {
	default?: string;
	defaultThinkingLevel?: string;
	categories: Record<string, RuleCategory>;
}

/** state: カテゴリ判定結果 (セッション branch 内で保持)。 */
interface RouterState {
	category: string;
	modelId: string;
	thinkingLevel?: string;
}

type RouterRequest = ModelRouteRequest<RouterState>;

const fs = await import("node:fs");
const os = await import("node:os");
const path = await import("node:path");

function expandTilde(p: string): string {
	return p.startsWith("~") ? path.join(os.homedir(), p.slice(1)) : p;
}

function loadRules(): RouterRules {
	const file = expandTilde(RULES_PATH);
	try {
		const raw = fs.readFileSync(file, "utf8");
		const rules = JSON.parse(raw) as RouterRules;
		if (!rules || typeof rules !== "object" || !rules.categories) {
			throw new Error("categories フィールドがありません");
		}
		return rules;
	} catch (error) {
		// ルールが読めないときは例外を投げず静かに既定動作に落とす
		console.error(`[json-router] ルール JSON の読み込みに失敗: ${file}`);
		console.error(`[json-router] ${String(error)}`);
		return { categories: {} };
	}
}

function lastUserText(messages: readonly Message[]): string {
	const content =
		messages.filter((m) => m.role === "user").at(-1)?.content ?? "";
	if (typeof content === "string") return content;
	return content
		.flatMap((block) => (block.type === "text" ? [block.text] : []))
		.join("\n");
}

/** Jev classifier にプロンプトを投げてカテゴリを判定する。失敗時は null。 */
async function classifyCategory(
	ctx: ExtensionContext,
	rules: RouterRules,
	prompt: string,
	signal: AbortSignal | undefined,
): Promise<string | null> {
	const jevId = rules.classifier?.model ?? "~typesafe/jev-latest";
	const jev = ctx.modelRegistry.findOfType(
		"classifier",
		"openrouter",
		jevId,
	);
	if (!jev) {
		console.error(`[json-router] classifier ${jevId} が見つかりません`);
		return null;
	}
	const categoryNames = Object.keys(rules.categories);
	if (categoryNames.length === 0) return null;

	const result = await ctx.modelRegistry.classify(
		jev,
		{
			state: { prompt: prompt.slice(0, 16_000) },
			questions: {
				category: {
					type: "choice",
					instructions:
						"Which kind of work does the prompt request? Pick the single best category.",
					criteria: Object.fromEntries(
						categoryNames.map((name) => {
							const rule = rules.categories[name];
							return [name, rule.description ?? name];
						}),
					),
				},
			},
		},
		{ signal },
	);
	if (result.stopReason !== "stop") return null;
	const answer = result.answers.category;
	if (answer.type !== "choice") return null;
	return categoryNames.includes(answer.choice) ? answer.choice : null;
}

/** ルールから振り分け先 (model, thinkingLevel) を引く。 */
function resolveRoute(
	rules: RouterRules,
	category: string | null,
): { modelId: string; thinkingLevel?: string } {
	if (category && rules.categories[category]) {
		return {
			modelId: rules.categories[category].model,
			thinkingLevel: rules.categories[category].thinkingLevel,
		};
	}
	return {
		modelId: rules.default ?? Object.values(rules.categories)[0]?.model,
		thinkingLevel: rules.defaultThinkingLevel,
	};
}

export default function (pi: ExtensionAPI) {
	pi.registerVirtualModel<RouterState>({
		provider: "router",
		id: "auto",
		name: "Auto (JSON Router)",
		thinkingLevels: ["off", "low", "medium", "high", "xhigh", "max"],
		async route(request, ctx) {
			// コンパクション要約など agent loop 外のリクエストは既定へ。
			if (request.reason === "direct") {
				const rules = loadRules();
				const r = resolveRoute(rules, null);
				const model = ctx.modelRegistry.find("openrouter", r.modelId);
				if (!model) throw new Error(`openrouter/${r.modelId} がカタログにありません`);
				return { model, thinkingLevel: r.thinkingLevel ?? "medium" };
			}

			// sticky routing: tool 結果や継続リクエストは同じモデルに留める
			const sticky = request.failed ?? request.previous;
			if (request.reason !== "user" && sticky) {
				return {
					model: sticky.model,
					thinkingLevel: sticky.thinkingLevel ?? "medium",
				};
			}

			// 既に state があるときは再判定せずそのまま使う (キャッシュ miss 回避)。
			if (request.state) {
				const model = ctx.modelRegistry.find("openrouter", request.state.modelId);
				if (model) {
					return {
						model,
						thinkingLevel: request.state.thinkingLevel ?? request.thinkingLevel,
						state: request.state,
					};
				}
			}

			// 新規ユーザーメッセージ: Jev classifier でカテゴリ判定。
			const rules = loadRules();
			const prompt = lastUserText(request.messages);
			const category = await classifyCategory(ctx, rules, prompt, request.signal);
			const r = resolveRoute(rules, category);
			const model = ctx.modelRegistry.find("openrouter", r.modelId);
			if (!model) throw new Error(`openrouter/${r.modelId} がカタログにありません`);
			const state: RouterState = {
				category: category ?? "(default)",
				modelId: r.modelId,
				thinkingLevel: r.thinkingLevel,
			};
			return {
				model,
				thinkingLevel: r.thinkingLevel ?? request.thinkingLevel,
				state,
			};
		},
	});
}