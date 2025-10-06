
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obs-studio
    xwayland-satellite
  ];
}
