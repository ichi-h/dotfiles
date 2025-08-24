{ pkgs, enableGuiPkg, ... }:
{
  home.packages = if enableGuiPkg then with pkgs; [
    bitwarden-desktop
    discord
    vivaldi
    obs-studio
    vscode
  ] else [];
}
