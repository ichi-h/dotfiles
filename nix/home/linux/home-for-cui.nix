{ config, pkgs, vars, ... }:
{
  imports = [
    ../base/cli
    ../base/home.nix
    ./base
  ];
  home.homeDirectory = "/home/${vars.username}";
}
