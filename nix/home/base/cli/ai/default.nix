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
      repository = "ichi-h/skills";
      skills = [ "task-management" ];
      agents = allAgents;
    }
    {
      repository = "mattpocock/skills";
      skills = [ "grilling" ];
      agents = allAgents;
    }
    {
      repository = "herdrdev/herdr";
      skills = [ "herdr" ];
      agents = allAgents;
    }
  ];
}
