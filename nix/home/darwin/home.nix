{ config, pkgs, vars, impurelibs, ... }:
{
  imports = [
    ../base/cli
    ../base/home.nix
  ];

  home = {
    homeDirectory = "/Users/${impurelibs.secrets.username}";
    file.".config/karabiner/karabiner.json" = {
      source = ./karabiner.json;
    };
  };
}
