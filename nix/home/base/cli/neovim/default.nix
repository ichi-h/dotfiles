{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];
    initLua = builtins.readFile ./init.lua;
    withRuby = false;
    withPython3 = false;
  };
}
