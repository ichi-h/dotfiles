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
  home.packages = [
    piDefault
  ];

  home.file = {
    ".pi/agent/settings.json".text = builtins.toJSON {
      lastChangelogVersion = piDefault.version;
      defaultProvider = "openrouter";
      defaultModel = "deepseek/deepseek-v4.1-flash-1017";
    };

    ".pi/agent/auth.json".text = builtins.toJSON {
      openrouter = {
        type = "api_key";
        key = impurelibs.secrets.openrouter-api-key-for-pi;
      };
    };
  };
}
