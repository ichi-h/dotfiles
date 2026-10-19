{ pkgs, herdr, ... }:
{
  home.packages = [
    herdr.packages.${pkgs.system}.default
  ];
}
