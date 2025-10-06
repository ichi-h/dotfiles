{ pkgs, vars, ... }:
{
  home.file.".local/share/applications/code.desktop".text =
  builtins.replaceStrings
    [ "Exec=code %F" ]
    [ ("Exec=code " + vars.x11-args + " %F") ]
    (builtins.readFile "${pkgs.vscode}/share/applications/code.desktop");

  home.file.".local/share/applications/discord.desktop".text =
    builtins.replaceStrings
      [ "Exec=Discord" ]
      [ ("Exec=Discord " + vars.x11-args) ]
      (builtins.readFile "${pkgs.discord}/share/applications/discord.desktop");

  home.file.".local/share/applications/bitwarden.desktop".text =
    builtins.replaceStrings
      [ "Exec=bitwarden %U" ]
      [ ("Exec=bitwarden " + vars.x11-args + " %U") ]
      (builtins.readFile "${pkgs.bitwarden}/share/applications/bitwarden.desktop");
}
