{ config, pkgs, vars, ... }:
{
  imports = [
    ../base/cli
    ../base/home.nix
  ];
  home.homeDirectory = "/home/${vars.username}";
}
