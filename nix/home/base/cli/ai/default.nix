{
  imports = [
    ./copilot-cli
    ./claude-code
    ./mcp
  ];

  home.file = {
    ".copilot/copilot-instructions.md".source = ./AGENTS.md;
    ".copilot/mcp-config.json".source = ./mcp/mcp-config.json;
    ".copilot/skills".source = ./skills;
    ".copilot/agents".source = ./agents;

    ".claude/CLAUDE.md".source = ./AGENTS.md;
    ".claude/mcp-config.json".source = ./mcp/mcp-config.json;
    ".claude/skills".source = ./skills;
    ".claude/agents".source = ./agents;
  };
}
