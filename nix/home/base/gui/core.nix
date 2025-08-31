{ pkgs, enableGuiPkg, ... }:
{
  home.packages = if enableGuiPkg then with pkgs; [
    bitwarden-desktop
    vscode
    obs-studio
    discord
  ] else [];
}
