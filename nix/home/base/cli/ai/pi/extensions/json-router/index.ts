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
 *
 * thinking effort の自動調整:
 *   カテゴリの thinkingLevel が未指定のとき、同じ classify 呼び出しで
 *   「このタスクに必要な推論深度」も聞いて (score)、その結果で補完する。
 *   明示指定があるカテゴリは指定値を優先し、pi 側のクランプに任せる。
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

/** classify の判定結果 (カテゴリ + 自動調整された thinking level)。 */
interface Classification {
	category: string | null;
	/** Jev が判定した推論深度 (未指定の thinkingLevel を補う)。 */
	thinkingLevel?: string;
}

/**
 * Jev classifier にプロンプトを投げてカテゴリと推論深度を判定する。
 * 1 回の classify 呼び出しで両方を聞くのでレイテンシ増はゼロ。
 * thinkingLevel は thinking effort 未指定のカテゴリの補完に使う。
 */
async function classifyPrompt(
	ctx: ExtensionContext,
	rules: RouterRules,
	prompt: string,
	signal: AbortSignal | undefined,
): Promise<Classification> {
	const jevId = rules.classifier?.model ?? "~typesafe/jev-latest";
	const jev = ctx.modelRegistry.findOfType(
		"classifier",
		"openrouter",
		jevId,
	);
	if (!jev) {
		console.error(`[json-router] classifier ${jevId} が見つかりません`);
		return { category: null };
	}
	const categoryNames = Object.keys(rules.categories);
	if (categoryNames.length === 0) return { category: null };

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
				/**
				 * thinking effort の自動調整。
				 * ルールで thinkingLevel が未指定のカテゴリにだけ使う。
				 * score (0..3) → low..max に丸める。trivial 判定でも off には
				 * 落とさない (off はルールで明示指定したときだけ)。
				 */
				depth: {
					type: "score",
					instructions:
						"How much reasoning does completing this task require?",
					criteria: [
						"low: ordinary fixes, small features, or questions with a clear approach",
						"medium: multi-file changes, design choices, or careful debugging",
						"high: cross-cutting refactors, subtle bugs, or architectural decisions",
						"max: research-level analysis, security reasoning, or novel design",
					],
				},
			},
		},
		{ signal },
	);
	if (result.stopReason !== "stop") return { category: null };

	const categoryAnswer = result.answers.category;
	const category =
		categoryAnswer.type === "choice" && categoryNames.includes(categoryAnswer.choice)
			? categoryAnswer.choice
			: null;

	// score (0..3) を pi の thinking level (low..max) へ丸める。
	// off は自動調整では使わない: ルールでの明示指定のみ許可。
	const LEVELS = ["low", "medium", "high", "max"];
	const depthAnswer = result.answers.depth;
	let thinkingLevel: string | undefined;
	if (depthAnswer.type === "score") {
		const idx = Math.round(depthAnswer.score);
		thinkingLevel = LEVELS[Math.min(Math.max(idx, 0), LEVELS.length - 1)];
	}
	return { category, thinkingLevel };
}

/** ルールから振り分け先 (model, thinkingLevel) を引く。 */
function resolveRoute(
	rules: RouterRules,
	category: string | null,
	/** Jev が判定した推論深度 (未指定のカテゴリの補完に使う)。 */
	autoThinkingLevel?: string,
): { modelId: string; thinkingLevel?: string } {
	if (category && rules.categories[category]) {
		const rule = rules.categories[category];
		return {
			modelId: rule.model,
			// ルールで明示指定されていればそれを優先、未指定なら Jev 判定で補完
			thinkingLevel: rule.thinkingLevel ?? autoThinkingLevel,
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

			// 新規ユーザーメッセージ: Jev classifier でカテゴリと推論深度を判定。
			const rules = loadRules();
			const prompt = lastUserText(request.messages);
			const { category, thinkingLevel: autoLevel } = await classifyPrompt(
				ctx,
				rules,
				prompt,
				request.signal,
			);
			const r = resolveRoute(rules, category, autoLevel);
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