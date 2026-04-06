{ config, pkgs, vars, impurelibs, ... }:
{
  imports = [
    ../base/cli
    ../base/gui
    ../base/home.nix
    ./base
    ./gui
  ];
  home.homeDirectory = "/home/${impurelibs.secrets.username}";
}
