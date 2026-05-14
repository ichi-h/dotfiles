{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_24
    nodePackages.pnpm
  ];

  home.file.".npmrc".text = ''
    min-release-age=7
  '';
}
