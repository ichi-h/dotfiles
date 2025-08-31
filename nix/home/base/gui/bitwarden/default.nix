{ pkgs, enableGuiPkg, vars, ... }:
{
  home.packages = if enableGuiPkg then with pkgs; [
    bitwarden-desktop
  ] else [];

  home.file.".local/share/applications/bitwarden.desktop".text =
    builtins.replaceStrings
      [ "Exec=bitwarden %U" ]
      [ ("Exec=bitwarden " + vars.x11-args + " %U") ]
      (builtins.readFile "${pkgs.bitwarden}/share/applications/bitwarden.desktop");
}
