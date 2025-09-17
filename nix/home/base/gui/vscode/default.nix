{ pkgs, vars, ... }:
{
  home.packages = with pkgs; [
    vscode
  ];

  home.file.".local/share/applications/code.desktop".text =
    builtins.replaceStrings
      [ "Exec=code %F" ]
      [ ("Exec=code " + vars.x11-args + " %F") ]
      (builtins.readFile "${pkgs.vscode}/share/applications/code.desktop");
}
