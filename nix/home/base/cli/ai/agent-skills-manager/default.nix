# npx skills を使って GitHub 上のスキルを宣言的に管理するモジュール。
#
# Home Manager の activation で `npx skills add/remove` を実行する。
# ここで宣言した内容を「あるべき状態」とし、現在のインストール状態との
# 差分だけを反映する。設定は Nix 上でのみ管理する (外部 JSON は使わない)。
#
# 使い方:
#   imports = [ ./agent-skills-manager ];
#
#   agentSkillsManager.sources = [
#     {
#       repository = "vercel-labs/agent-skills";
#       skills = [ "web-design-guidelines" ];
#       agents = [ "claude-code" "pi" ]; # 省略時はすべてのエージェント
#     }
#   ];
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.agentSkillsManager;

  specJson = pkgs.writeText "agent-skills-manager-spec.json" (
    builtins.toJSON {
      inherit (cfg) npxPackage prune;
      # agents が空の場合はキー自体を出力しない
      # (スクリプト側で「すべてのエージェント」と解釈される)。
      sources = map (
        source:
        {
          inherit (source) repository skills;
        }
        // lib.optionalAttrs (source.agents != [ ]) { inherit (source) agents; }
      ) cfg.sources;
    }
  );

  agentSkillsManager = pkgs.writeShellApplication {
    name = "agent-skills-manager";
    runtimeInputs = [
      pkgs.nodejs
      pkgs.jq
      pkgs.git
    ];
    text = ''
      # テストや一時的な上書き用に、環境変数での差し替えを許す。
      export AGENT_SKILLS_MANAGER_SPEC="''${AGENT_SKILLS_MANAGER_SPEC:-${specJson}}"
      exec ${pkgs.bash}/bin/bash ${./sync.sh} "$@"
    '';
  };
in
{
  options.agentSkillsManager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "npx skills によるスキル管理を有効にする。";
    };

    npxPackage = lib.mkOption {
      type = lib.types.str;
      default = "skills@1.7.2";
      description = "npx で実行する skills パッケージ。バージョンを固定して再現性を保つ。";
    };

    prune = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        true の場合、ここで宣言していないスキルを削除する。
        ただし npx skills の lock に記録がないスキル
        (Home Manager が直接配置しているもの) は対象外。
      '';
    };

    sources = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            repository = lib.mkOption {
              type = lib.types.str;
              example = "vercel-labs/agent-skills";
              description = "GitHub のリポジトリ (owner/repo 形式)。";
            };

            skills = lib.mkOption {
              type = lib.types.nonEmptyListOf lib.types.str;
              example = [ "web-design-guidelines" ];
              description = "インストールするスキル名。";
            };

            agents = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              example = [
                "claude-code"
                "codex"
                "pi"
              ];
              description = ''
                インストール先のエージェント (npx skills の agent ID。
                例: claude-code, codex, pi, gemini-cli, github-copilot)。
                空の場合はすべてのエージェントを対象とする。
              '';
            };
          };
        }
      );
      default = [ ];
      description = "インストールするスキルの一覧。";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ agentSkillsManager ];

    # ネットワークアクセスを伴うため、失敗しても switch 全体は止めない。
    # 手動で `agent-skills-manager` を実行すれば差分を再適用できる。
    home.activation.agentSkillsManager = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      verboseEcho "npx skills のスキルを同期しています"
      $DRY_RUN_CMD ${agentSkillsManager}/bin/agent-skills-manager || verboseEcho "スキルの同期に失敗しました。agent-skills-manager を手動で実行してください"
    '';
  };
}
