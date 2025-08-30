{ config, pkgs, vars, ... }:
{
  imports = [
    ../base/cli
    ../base/gui
    ../base/home.nix
    ./gui
  ];
  home.homeDirectory = "/home/${vars.username}";
}
