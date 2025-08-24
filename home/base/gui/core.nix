{ pkgs, enableGuiPkg, ... }:
{
  home.packages = if enableGuiPkg then with pkgs; [
    bitwarden-desktop
    vivaldi
    obs-studio
    vscode
  ] else [];
}
