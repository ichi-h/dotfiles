{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    fastfetch
    tree
    bitwarden-cli
    wakeonlan
  ];
}
