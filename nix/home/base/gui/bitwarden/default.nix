{ pkgs, vars, ... }:
{
  home.packages = with pkgs; [
    bitwarden-desktop
  ];

  home.file.".local/share/applications/bitwarden.desktop".text =
    builtins.replaceStrings
      [ "Exec=bitwarden %U" ]
      [ ("Exec=bitwarden " + vars.x11-args + " %U") ]
      (builtins.readFile "${pkgs.bitwarden}/share/applications/bitwarden.desktop");
}
