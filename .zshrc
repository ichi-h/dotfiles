#!/usr/bin/zsh

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export HISTFILESIZE=2000
export SAVEHIST=1000
setopt INC_APPEND_HISTORY

autoload -Uz compinit && compinit # activate completion

setopt auto_cd # omit cd command
alias ...='cd ../..'
alias ....='cd ../../..'
alias la='ls -laFG'
alias l='ls -CFG'

export PATH="$PATH:$HOME/dotfiles/bin"

source ~/.env

# For osx

if [ $USER_DEVICE = "mac" ]; then
  # pyenv
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi

  # nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  # Rust
  export RUST_HOME=/usr/local/lib/rust
  export RUSTUP_HOME="$RUST_HOME"/rustup
  export CARGO_HOME="$HOME"/.cargo
  source "$CARGO_HOME"/env
fi

# For Linux

if [ $USER_DEVICE = "ubuntu" ]; then
  # nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

  # ngrok
  export PATH="$PATH:$HOME/.ngrok2/bin"

  # deno
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"

  . "$HOME/.cargo/env"
fi

# For WSL

if [ $USER_DEVICE = "wsl" ]; then
  # (WSL) Omit the ext of Windows exec
  # https://unix.stackexchange.com/questions/612352/how-to-run-windows-executables-from-terminal-without-the-explicitly-specifying-t
  function command_not_found_handler {
    exts=".exe;.com;.bat;.cmd;.vbs;.vbe;.js;.jse;.wsf;.wsh;.msc;"$PATHEXT
    for ext in ${(s:;:)${exts}}; do
      if [ $+commands[$1$ext] -eq 1 ]; then
        exec -- "$1$ext" "${@:2}"
      fi
    done
    print -ru2 "command not found: $1"
    return 127
  }

  export win_home="$HOME/win_home"
  export win_project="$HOME/win_project"

  # nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi

# zstyle

autoload -U colors ; colors ; zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# zinit

## Added by Zinit's installer

if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## Load a few important annexes, without Turbo
## (this is currently required for annexes)

zinit light-mode for \
  zdharma-continuum/z-a-rust \
  zdharma-continuum/z-a-as-monitor \
  zdharma-continuum/z-a-patch-dl \
  zdharma-continuum/z-a-bin-gem-node

## Oh My Zsh Setup

setopt promptsubst

## Plugins

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/history-search-multi-word
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice atclone"chmod +x zlitefetch.zsh"
zinit light ichi-h/zlitefetch
export ZLITEFETCH_COLOR="\e[38;5;141m"
zlitefetch --off

# typewritten 

## Set Dracula theme

ZSH_THEME="typewritten"

export TYPEWRITTEN_SYMBOL="λ "
export DRACULA_TYPEWRITTEN_COLOR_MAPPINGS="primary:#d5ccff;secondary:#9580ff;info_neutral_1:#d0ffcc;info_neutral_2:#ffffcc;info_special:#ff9580;info_negative:#ff5555;notice:#ffff80;accent:#d5ccff"
export TYPEWRITTEN_COLOR_MAPPINGS="${DRACULA_TYPEWRITTEN_COLOR_MAPPINGS}"
export TYPEWRITTEN_PROMPT_LAYOUT="pure"
export TYPEWRITTEN_CURSOR="block"

## Set typewritten ZSH as a prompt

fpath=($fpath "$HOME/.zfunctions")
autoload -U promptinit; promptinit
prompt typewritten
