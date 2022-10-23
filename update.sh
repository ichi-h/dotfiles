#!/usr/bin/bash

# Clone tmux-plugins/tpm
if [ ! -e ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install typewritten
npm list -g --depth=0 | grep 'typewritten' >/dev/null
if [ $? -eq 1 ]; then
  npm install -g typewritten
fi

# Create directories
if [ ! -e ~/.config ]; then
  mkdir -p ~/.config
fi

if [ ! -e ~/.config/git ]; then
  mkdir -p ~/.config/git
fi

# Create the sylinks of the dotfiles
links=(~/.gitconfig ~/.zshenv ~/.zshrc ~/.vimrc ~/.config/git/ignore ~/dein.vim ~/.tmux.conf ~/.env)
for link in ${links[@]}; do
  if [ ! -e $link ]; then
    file_name=`basename $link`
    ln -s ~/dotfiles/$file_name $link
    echo Create $link sylink.
  fi
done

# Change the permission of the script files in ~/dotfiles/bin/
scripts=`find ~/dotfiles/bin/ -type f`
for script in ${scripts[@]}; do
  chmod 700 $script
done
