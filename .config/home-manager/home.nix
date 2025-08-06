{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ichi";
  home.homeDirectory = "/home/ichi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    zsh
    curl
    tmux
    fastfetch
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "dein.vim".source = ../../dein.vim;
    ".gitconfig".source = ../../.gitconfig;
    ".vimrc".source = ../../.vimrc;
    ".config/git".source = ../git;

    ".zsh/typewritten".source = pkgs.fetchFromGitHub {
      owner = "reobin";
      repo = "typewritten";
      rev = "v1.5.2";
      sha256 = "sha256-ZHPe7LN8AMr4iW0uq3ZYqFMyP0hSXuSxoaVSz3IKxCc=";
    };

    ".tmux/plugins/tpm".source = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tpm";
      rev = "v3.1.0";
      sha256 = "sha256-ZHPe7LN8AMr4iW0uq3ZYqFMyP0hSXuSxoaVSz3IKxCc=";
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ichi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
      "la" = "ls -laFG";
      "l" = "ls -CFG";
    };
    envExtra = ''
      export PATH="$PATH:$HOME/dotfiles/bin"
      export PATH="$PATH:$HOME/.local/bin"
      export PATH="$PATH:/usr/local/bin/"
      export PATH="$PATH:/usr/local/sbin/"
    '';
    initContent = ''
      source ~/dotfiles/.env

      PRIMARY_COLOR="#d5ccff"

      fastfetch \
        --color $PRIMARY_COLOR \
        --localip-show-ipv4 false \
        --localip-show-ipv6 false

      ZSH_THEME="typewritten"
      export TYPEWRITTEN_SYMBOL="λ "
      export DRACULA_TYPEWRITTEN_COLOR_MAPPINGS="primary:$PRIMARY_COLOR;secondary:#9580ff;info_neutral_1:#d0ffcc;info_neutral_2:#ffffcc;info_special:#ff9580;info_negative:#ff5555;notice:#ffff80;accent:$PRIMARY_COLOR"
      export TYPEWRITTEN_COLOR_MAPPINGS="$DRACULA_TYPEWRITTEN_COLOR_MAPPINGS"
      export TYPEWRITTEN_PROMPT_LAYOUT="pure"
      export TYPEWRITTEN_CURSOR="block"

      fpath=($fpath "$HOME/.zsh/typewritten")
      autoload -U promptinit; promptinit
      prompt typewritten
    '';
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
    ];
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    extraConfig = ''
      set -g prefix C-t
      unbind C-b

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # tmux theme
      set -g @plugin 'dracula/tmux'
      set -g @dracula-show-powerline true
      set -g @dracula-show-flags true
      set -g @dracula-plugins "weather"
      set -g @dracula-show-fahrenheit false
      set -g @dracula-show-left-icon 

      # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
