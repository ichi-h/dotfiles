{ lib, ... }:
let
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

in
{
  home.file = claudeAgentEntries // copilotAgentEntries;
}
