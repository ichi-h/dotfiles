{ config, pkgs, ... }:
{
  imports = [
    ../base/cli
    ../base/gui
    ../base/home.nix
  ];
  home.homeDirectory = "/Users/ichi";
}
