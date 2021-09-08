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

# zplug
if [ "`uname -s`" = "Linux" ]; then
	export ZPLUG_HOME=~/.zplug
elif [ "`uname -s`" = "Darwin" ]; then
	export ZPLUG_HOME=/usr/local/opt/zplug
fi

source $ZPLUG_HOME/init.zsh

## プラグイン一覧
zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "ippee/ys", as:theme

## プラグインのインストール
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

## コマンドの読み込み
zplug load

