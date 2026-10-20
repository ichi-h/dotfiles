/**
 * "Package Updates Available" の起動時通知を抑制する extension。
 *
 * pi 1.3.0 には通知を止める設定が無く、`quietStartup` でも消えない
 * (dist/modes/interactive/interactive-mode.js:845-849 が無条件に showPackageUpdateNotification を呼ぶ)。
 * ここでは InteractiveMode.prototype.showPackageUpdateNotification を差し替えて描画だけを止める。
 * 更新チェック自体はそのまま走るため、結果は `/package-updates` で確認できる。
 *
 * 呼び出し順: extension の読み込み (この module の評価) → InteractiveMode.run() の通知。
 * そのため module の top-level で差し替えれば起動時の通知に間に合う。
 */
import { InteractiveMode } from "@earendil-works/pi-coding-agent";

type ExtensionAPI = import("@earendil-works/pi-coding-agent").ExtensionAPI;

/** 直近の起動時チェックで見つかった更新 (表示せずに保持する)。 */
let pendingUpdates: string[] = [];

const proto = (InteractiveMode as unknown as { prototype: Record<string, unknown> })
  .prototype;
const originalShow = proto.showPackageUpdateNotification as
  | ((packages: string[]) => void)
  | undefined;

if (typeof originalShow === "function") {
  proto.showPackageUpdateNotification = function (packages: string[]): void {
    pendingUpdates = packages;
  };
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("package-updates", {
    description: "Show updates found at startup (suppressed by no-package-update-notice)",
    handler: async (_args, ctx) => {
      if (pendingUpdates.length === 0) {
        ctx.ui.notify("No package updates available.", "info");
        return;
      }
      const lines = pendingUpdates.map((pkg) => `- ${pkg}`).join("\n");
      ctx.ui.notify(
        `Package updates available. Run pi update --extensions\n${lines}`,
        "info",
      );
    },
  });
}
