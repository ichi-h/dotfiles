source ~/dotfiles/.env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PRIMARY_COLOR="#d5ccff"
SECONDARY_COLOR="#9580ff"

fastfetch \
  --color $PRIMARY_COLOR \
  --structure "title:separator:os:host:kernal:uptime:shell:terminal:cpu:gpu:memory:swap:disk:locale"

ZSH_THEME="typewritten"
export TYPEWRITTEN_SYMBOL="λ "
export DRACULA_TYPEWRITTEN_COLOR_MAPPINGS="primary:$PRIMARY_COLOR;secondary:$SECONDARY_COLOR;info_neutral_1:#d0ffcc;info_neutral_2:#ffffcc;info_special:#ff9580;info_negative:#ff5555;notice:#ffff80;accent:$PRIMARY_COLOR"
export TYPEWRITTEN_COLOR_MAPPINGS="$DRACULA_TYPEWRITTEN_COLOR_MAPPINGS"
export TYPEWRITTEN_PROMPT_LAYOUT="pure"
export TYPEWRITTEN_CURSOR="block"

fpath=($fpath "$HOME/.zsh/typewritten")
autoload -U promptinit; promptinit
prompt typewritten
