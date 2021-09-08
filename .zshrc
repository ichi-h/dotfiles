# 補完の有効化
autoload -Uz compinit && compinit

# cdの省略
setopt auto_cd
alias ...='cd ../..'
alias ....='cd ../../..'

# コマンドの履歴
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export HISTFILESIZE=2000
export SAVEHIST=1000
setopt INC_APPEND_HISTORY

# alias
alias la='ls -laFG'
alias l='ls -CFG'

# (WSL) .exeの省略
# https://unix.stackexchange.com/questions/612352/how-to-run-windows-executables-from-terminal-without-the-explicitly-specifying-t
function command_not_found_handler {
  for ext in ${(s:;:)${PATHEXT-".com;.exe;.bat;.cmd;.vbs;.vbe;.js;.jse;.wsf;.wsh;.msc"}}; do
  if (( $+commands[$1$ext] )); then
    exec -- "$1$ext" "${@:2}"
  fi
  done
  print -ru2 "command not found: $1"
  return 127
}

# zinit
## Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## Load a few important annexes, without Turbo
## (this is currently required for annexes)
zinit light-mode for \
  zinit-zsh/z-a-rust \
  zinit-zsh/z-a-as-monitor \
  zinit-zsh/z-a-patch-dl \
  zinit-zsh/z-a-bin-gem-node

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
zinit light zdharma/history-search-multi-word

# For osx
if [ `uname -s` = "Darwin" ]; then
  zinit light zdharma/fast-syntax-highlighting
fi
