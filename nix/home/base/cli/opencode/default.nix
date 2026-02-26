{
  pkgs,
  inputs ? { },
  ...
}:
let
  opencodeBase =
    if inputs ? opencode then
      inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default
    else
      pkgs.opencode;
in
{
  programs.opencode = {
    enable = true;
    package = opencodeBase;
    settings = {
      autoupdate = false;
      share = "manual";
      plugin = [
        "oh-my-opencode"
      ];
    };
  };
}
