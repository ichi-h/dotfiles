{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    fastfetch
    tree
    wakeonlan
    nodejs_24
    nodePackages.pnpm
    bashInteractive
    nixfmt
  ];
}
