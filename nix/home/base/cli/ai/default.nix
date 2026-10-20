let
  allAgents = [
    "antigravity-cli"
    "claude-code"
    "codex"
    "github-copilot"
    "pi"
  ];
in
{
  imports = [
    ./antigravity-cli
    ./claude-code
    ./codex
    ./copilot-cli
    ./mcp
    ./pi
    ./agents
    ./agent-skills-manager
  ];

  agentSkillsManager.sources = [
    {
      repository = "mattpocock/skills";
      skills = [ "grilling" ];
      agents = allAgents;
    }
  ];
}
