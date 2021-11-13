# Activate completion
autoload -Uz compinit && compinit

# Omit cd command
setopt auto_cd
alias ...='cd ../..'
alias ....='cd ../../..'

# Command history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export HISTFILESIZE=2000
export SAVEHIST=1000
setopt INC_APPEND_HISTORY

# Aliases
alias la='ls -laFG'
alias l='ls -CFG'

# (WSL) Omit the ext of Windows exec
# https://unix.stackexchange.com/questions/612352/how-to-run-windows-executables-from-terminal-without-the-explicitly-specifying-t
if [ `uname -s` = "Linux" ]; then
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
fi

# zstyle
autoload -U colors ; colors ; zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# zinit
## Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}z-shell/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/z-shell/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## Load a few important annexes, without Turbo
## (this is currently required for annexes)
zinit light-mode for \
  z-shell/z-a-rust \
  z-shell/z-a-as-monitor \
  z-shell/z-a-patch-dl \
  z-shell/z-a-bin-gem-node

## Oh My Zsh Setup
setopt promptsubst

zinit for \
  OMZL::prompt_info_functions.zsh \
  OMZL::theme-and-appearance.zsh \
  OMZT::ys.zsh-theme
zinit snippet OMZL::git.zsh
zinit ice atload"unalias grv"
zinit snippet OMZP::git

## Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light z-shell/history-search-multi-word

zinit ice atclone"chmod +x zlitefetch.zsh"
zinit light ichi-h/zlitefetch

# For osx
if [ `uname -s` = "Darwin" ]; then
  zinit light z-shell/fast-syntax-highlighting
fi

# Display system information
zlitefetch

