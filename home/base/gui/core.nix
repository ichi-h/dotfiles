{ pkgs, enableGuiPkg, ... }:
{
  home.packages = if enableGuiPkg then with pkgs; [
    bitwarden-desktop
    vscode
  ] else [];
}
