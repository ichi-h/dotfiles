{ pkgs, ... }:
{
  home.packages = with pkgs; [
    copilot-cli
  ];
}
