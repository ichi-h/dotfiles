{ pkgs, enableGuiPkg, ... }:
{
  home.packages = if enableGuiPkg then with pkgs; [
    bitwarden-desktop
    vscode
    vivaldi
    obs-studio
    discord
  ] else [];
}
