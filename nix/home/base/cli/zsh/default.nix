{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    autocd = true;
    history = {
      append = true;
      ignoreAllDups = true;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 1000;
      size = 1000;
      share = true;
    };
    historySubstringSearch = {
      enable = true;
    };
    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "la" = "ls -laFGh";
    };
    variables = {
      LANG = "ja_JP.UTF-8";
      LC_ALL = "ja_JP.UTF-8";
    };
    envExtra = builtins.readFile ./.zshenv;
    initContent = builtins.readFile ./.zshrc;
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
      {
        name = "typewritten";
        file = "typewritten.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "reobin";
          repo = "typewritten";
          rev = "v1.5.2";
          sha256 = "sha256-ZHPe7LN8AMr4iW0uq3ZYqFMyP0hSXuSxoaVSz3IKxCc=";
        };
      }
    ];
  };
}
