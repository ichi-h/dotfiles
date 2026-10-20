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

    ".pi/agent/AGENTS.md".source = ../AGENTS.md;
  };
}
