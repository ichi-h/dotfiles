{
  pkgs,
  pi,
  impurelibs,
  ...
}:
let
  piDefault = pi.packages.${pkgs.system}.default;
in
{
  imports = [
    (import ./extensions ".pi/agent/extensions")
  ];

  home.packages = [
    piDefault
  ];

  home.file = {
    ".pi/agent/settings.json".text = builtins.toJSON {
      lastChangelogVersion = piDefault.version;
      defaultProvider = "openrouter";
      defaultModel = "deepseek/deepseek-v4.1-flash-1017";
      defaultThinkingLevel = "low";
      packages = [
        "npm:billion-context"
        "npm:pi-web-access"
        "npm:pi-subagents"
        "npm:@juicesharp/rpiv-ask-user-question"
        "npm:@juicesharp/rpiv-todo"
        "npm:cc-safety-net"
      ];
    };

    ".pi/agent/auth.json".text = builtins.toJSON {
      openrouter = {
        type = "api_key";
        key = impurelibs.secrets.openrouter-api-key-for-pi;
      };
    };

    ".pi/agent/mcp.json".text = ''
      {
        "mcpServers" : ${builtins.readFile ../mcp/mcp-config.json}
      }
    '';

    ".pi/agent/AGENTS.md".source = ../AGENTS.md;
    ".pi/agent/router-rules.json".source = ./router-rules.json;
  };
}
