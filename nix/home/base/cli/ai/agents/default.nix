{ lib, pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
  serena = (builtins.fromJSON (builtins.readFile ../mcp/mcp-config.json)).serena;

  agents = [
    (import ./orchestrator)
    (import ./implementer)
    (import ./investigator)
    (import ./system-designer)
    (import ./plan-orchestrator)
    (import ./quick-orchestrator)
    (import ./code-reviewer)
    (import ./architecture-reviewer)
    (import ./performance-reviewer)
    (import ./security-reviewer)
    (import ./test-reviewer)
    (import ./domain-reviewer)
  ];

  # Claude Code用: "tool1, tool2, tool3" 形式
  mkClaudeToolsStr = tools: lib.concatStringsSep ", " tools;

  # Copilot CLI用: YAML inline block形式
  mkCopilotToolsYaml =
    tools:
    if tools == [ ] then "[]" else "[\n" + lib.concatMapStrings (t: "    \"${t}\",\n") tools + "  ]";

  mkFrontMatter =
    {
      name,
      description,
      toolsStr,
      model ? null,
    }:
    let
      modelLine = lib.optionalString (model != null) "\nmodel: ${model}";
    in
    ''
      ---
      name: ${name}
      description: ${description}${modelLine}
      tools: ${toolsStr}
      ---

    '';

  mkAgentMd =
    {
      name,
      description,
      toolsStr,
      model ? null,
      contentFile,
    }:
    mkFrontMatter {
      inherit
        name
        description
        toolsStr
        model
        ;
    }
    + builtins.readFile contentFile;

  claudeAgentEntries = lib.listToAttrs (
    map (agent: {
      name = ".claude/agents/${agent.name}.md";
      value.text = mkAgentMd {
        inherit (agent) name description;
        inherit (agent.claude) model;
        toolsStr = mkClaudeToolsStr agent.claude.tools;
        contentFile = ./. + "/${agent.name}/content.md";
      };
    }) agents
  );

  copilotAgentEntries = lib.listToAttrs (
    map (agent: {
      name = ".copilot/agents/${agent.name}.md";
      value.text = mkAgentMd {
        inherit (agent) name description;
        inherit (agent.copilot) model;
        toolsStr = mkCopilotToolsYaml agent.copilot.tools;
        contentFile = ./. + "/${agent.name}/content.md";
      };
    }) agents
  );

  # MCP のツール制限と sandbox は別の制約。接続設定は共通定義を再利用する。
  codexAgentFiles = map (
    agent: {
      name = "${agent.name}.toml";
      source = tomlFormat.generate "${agent.name}.toml" (
        lib.recursiveUpdate {
          inherit (agent) name description;
          mcp_servers.serena = {
            inherit (serena) command args;
            enabled_tools = map (lib.removePrefix "mcp__serena__") (
              builtins.filter (lib.hasPrefix "mcp__serena__") agent.claude.tools
            );
          };
        } agent.codex
      );
    }
  ) agents;

  # Codex はセキュリティ上、シンボリックリンクされたエージェント定義を読み込まない。
  # Home Manager の home.file はシンボリックリンクを作成するため、通常ファイルとして配置する。
  installCodexAgentFiles = lib.concatMapStringsSep "\n" (
    agentFile: ''
      $DRY_RUN_CMD rm -f "$HOME/.codex/agents/${agentFile.name}"
      $DRY_RUN_CMD cp "${agentFile.source}" "$HOME/.codex/agents/${agentFile.name}"
    ''
  ) codexAgentFiles;

in
{
  home.file = claudeAgentEntries // copilotAgentEntries;

  home.activation.installCodexAgentFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.codex/agents"
    ${installCodexAgentFiles}
  '';
}
