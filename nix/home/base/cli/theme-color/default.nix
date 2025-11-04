{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "theme-color" ''
      ${pkgs.nodejs}/bin/node ${./theme-color.js} "$@"
    '')
  ];
}
