#!/bin/bash

links=(~/.gitconfig ~/.zshenv ~/.zshrc ~/.vimrc ~/.config/git/ignore ~/.mycmd)

for link in ${links[@]}; do
  if [ ! -e $link ]; then
    file_name=`basename $link`
    ln -s ~/dotfiles/$file_name $link
    echo Create $link sylink.
  fi
done
