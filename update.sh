#!/bin/bash

# Create directories
if [ ! -e ~/.config ]; then
  mkdir -p ~/.config
fi

if [ ! -e ~/.config/git ]; then
  mkdir -p ~/.config/git
fi

# Create the sylinks of the dotfiles
links=(~/.gitconfig ~/.zshenv ~/.zshrc ~/.vimrc ~/.config/git/ignore ~/.mycmd ~/dein.vim ~/.tmux.conf ~/.env)
for link in ${links[@]}; do
  if [ ! -e $link ]; then
    file_name=`basename $link`
    ln -s ~/dotfiles/$file_name $link
    echo Create $link sylink.
  fi
done

# Change the permission of the script files in .mycmd/bin/
scripts=`find .mycmd/bin/ -type f`
for script in ${scripts[@]}; do
  chmod 700 $script
done
