{ pkgs, enableGuiPkg, vars, ... }:
{
  home.packages = if enableGuiPkg then with pkgs; [
    discord
  ] else [];

  home.file.".local/share/applications/discord.desktop".text =
    builtins.replaceStrings
      [ "Exec=Discord" ]
      [ ("Exec=Discord " + vars.wayland-ime-args) ]
      (builtins.readFile "${pkgs.discord}/share/applications/discord.desktop");
}
