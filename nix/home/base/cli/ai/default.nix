{ pkgs, task-management, ... }:
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
      repository = "ichi-h/task-management";
      skills = [
        "task-management"
        "commit-per-task"
        "review-to-ticket"
        "review-prepare"
        "review-dispatch"
        "review-integrate"
        "file-ticket"
      ];
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

  nixpkgs.overlays = [ task-management.overlays.default ];
  home.packages = [ pkgs.task-management-viewer ];
}
