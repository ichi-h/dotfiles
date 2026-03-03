{ pkgs, mcp-servers-nix, ... }:
{
  home.packages = [
    mcp-servers-nix.packages.${pkgs.system}.serena
    mcp-servers-nix.packages.${pkgs.system}.mcp-server-git
  ];
}
