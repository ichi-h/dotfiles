{ pkgs, enableGuiPkg, vars, ... }:
{
  home.packages = if enableGuiPkg then with pkgs; [
    vivaldi
  ] else [];

  home.file.".local/share/applications/vivaldi-stable.desktop".text =
    builtins.replaceStrings
      [ "vivaldi %U" ]
      [ ("vivaldi " + vars.wayland-ime-args + " %U") ]
      (builtins.readFile "${pkgs.vivaldi}/share/applications/vivaldi-stable.desktop");
}
