{ config, pkgs, vars, ... }:
{
  imports = [
    ../base/cli
    ../base/gui
    ../base/home.nix
  ];
  home.homeDirectory = "/home/${vars.username}";
}
