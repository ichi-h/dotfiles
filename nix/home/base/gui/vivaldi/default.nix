{ pkgs, vars, ... }:
{
  home.packages = with pkgs; [
    vivaldi
  ];

  home.file.".local/share/applications/vivaldi-stable.desktop".text =
    builtins.replaceStrings
      [ "vivaldi %U" ]
      [ ("vivaldi " + vars.wayland-ime-args + " %U") ]
      (builtins.readFile "${pkgs.vivaldi}/share/applications/vivaldi-stable.desktop");
}
