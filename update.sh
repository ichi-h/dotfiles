#!/bin/bash

# Create the sylinks of the dotfiles
links=(~/.gitconfig ~/.zshenv ~/.zshrc ~/.vimrc ~/.config/git/ignore ~/.mycmd)
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