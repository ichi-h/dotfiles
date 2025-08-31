{ pkgs, enableGuiPkg, ... }:
{
  home.packages = if enableGuiPkg then with pkgs; [
    bitwarden-desktop
    obs-studio
    discord
  ] else [];
}
