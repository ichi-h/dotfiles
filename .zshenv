#!/usr/bin/zsh

autoload -Uz compinit && compinit # activate completion

setopt auto_cd # omit cd command

alias ...='cd ../..'
alias ....='cd ../../..'
alias la='ls -laFG'
alias l='ls -CFG'

export PATH="$PATH:/usr/local/bin/"
export PATH="$PATH:/usr/local/sbin/"

export PATH="$PATH:$HOME/.mycmd/bin"
export PATH="$PATH:$HOME/.local/bin"
