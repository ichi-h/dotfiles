{ pkgs, mcp-servers-nix, ... }:
mcp-servers-nix.lib.mkConfig pkgs {
  programs = {
    serena = {
      enable = true;
      # args = [ "" ];
    };
  };
}
