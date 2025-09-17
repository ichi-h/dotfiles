{ pkgs, vars, ... }:
{
  home.packages = with pkgs; [
    discord
  ];

  home.file.".local/share/applications/discord.desktop".text =
    builtins.replaceStrings
      [ "Exec=Discord" ]
      [ ("Exec=Discord " + vars.x11-args) ]
      (builtins.readFile "${pkgs.discord}/share/applications/discord.desktop");
}
