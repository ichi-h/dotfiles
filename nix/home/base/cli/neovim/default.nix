{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig	
    ];
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
