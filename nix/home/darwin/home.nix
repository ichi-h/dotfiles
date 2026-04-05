{ config, pkgs, vars, ... }:
{
  imports = [
    ../base/cli
    ../base/home.nix
  ];

  home = {
    homeDirectory = "/Users/${vars.username}";
    file = {
      ".config/karabiner/karabiner.json".source = ./karabiner.json;
    };
  };
}
