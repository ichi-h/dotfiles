{ pkgs, pi, ... }:
{
  home.packages = [
    pi.packages.${pkgs.system}.default
  ];
}
