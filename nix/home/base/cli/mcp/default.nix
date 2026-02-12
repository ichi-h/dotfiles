{ pkgs, mcp-servers-nix, ... }:
{
  home.packages = [ mcp-servers-nix.packages.${pkgs.system}.serena ];
}
