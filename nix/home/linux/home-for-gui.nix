{ config, pkgs, vars, ... }:
{
  imports = [
    ../base/cli
    ../base/gui
    ../base/home.nix
    ./base
    ./gui
  ];
  home.homeDirectory = "/home/${vars.username}";
}
