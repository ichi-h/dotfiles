{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    fastfetch
    tree
    wakeonlan
    bashInteractive
    nixfmt
    gh
  ];
}
