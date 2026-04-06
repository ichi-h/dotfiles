{ config, pkgs, vars, impurelibs, ... }:
{
  imports = [
    ../base/cli
    ../base/home.nix
    ./base
  ];
  home.homeDirectory = "/home/${impurelibs.secrets.username}";
}
