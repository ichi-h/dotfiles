# 補完の有効化
autoload -Uz compinit && compinit

# cdの省略
setopt auto_cd
alias ...='cd ../..'
alias ....='cd ../../..'

# コマンドの履歴
export HISTFILE=${HOME}/.zsh_history
HISTSIZE=1000
HISTFILESIZE=2000

# alias
alias la='ls -laFG'
alias l='ls -CFG'

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

