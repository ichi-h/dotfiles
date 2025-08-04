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

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# For Fedora

if [ $USER_DEVICE = "fedora" ]; then
  # Lima BEGIN
  # Make sure iptables and mount.fuse3 are available
  export PATH="$PATH:/usr/sbin:/sbin"

  # nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  # ngrok
  export PATH="$PATH:$HOME/.ngrok/bin"

  # pnpm
  export PNPM_HOME="$HOME/.local/share/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac

  # Golang
  export PATH="$PATH:/usr/local/go/bin"
  export GOPATH="$HOME/go"
  export GOBIN="$GOPATH/bin"
  export PATH="$PATH:$GOBIN"

  # Deno
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# For WSL

if [ $USER_DEVICE = "wsl" ]; then
  export win_home="$HOME/win_home"
  export win_project="$HOME/win_project"

  export PATH="$PATH:$HOME/.ngrok/bin"
  export TERM="xterm-256color"

  # nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi

# For Raspberry Pi

if [ $USER_DEVICE = "raspberrypi" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
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
fpath=($fpath "/home/ichi/.zfunctions")
