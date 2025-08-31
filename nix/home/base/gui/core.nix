{ pkgs, enableGuiPkg, ... }:
{
  home.packages = if enableGuiPkg then with pkgs; [
    xwayland-satellite
    obs-studio
  ] else [];
}
