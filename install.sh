#!/bin/bash

# Prerequisites
# brew, node, vim

# oh my zsh

# brew
if [ which brew ]; then
  echo "install volta?"
  read
  if [[ $REPLY == "y" || $REPLY == "Y" || $REPLY == "Yes" ]]; then
    brew install volta


  fi

  brew install rg fd tmux neovim wezterm

  # scmpuff (git files numbered, gs/gd/gc etc)
  brew install scmpuff
  echo "eval \"$(scmpuff init -s)\"" >> $HOME/.zshrc
fi
  

ln -sf "$(pwd)/.gitconfig" $HOME/
ln -sf "$(pwd)/.gitconfig-personal" $HOME/
ln -sf "$(pwd)/.vimrc" $HOME/
ln -sf "$(pwd)/.tmux.conf" $HOME/
ln -sf "$(pwd)/.bash_profile" $HOME/
ln -sf "$(pwd)/.wezterm.lua" $HOME/

# make vim folders
mkdir $HOME/.vim/
mkdir $HOME/.vim/colors/
mkdir $HOME/.vim/autoload/

# open vim to PlugInstall
vim -c PlugInstall

# copy vim items to their folders
ln -s $HOME/.vim/plugged/onedark.vim/colors/onedark.vim $HOME/.vim/colors/onedark.vim
ln -s $HOME/.vim/plugged/onedark.vim/autoload/onedark.vim $HOME/.vim/autoload/onedark.vim

# Make sure to enable natural text editing on iTerm
# Prefs > Profiles > Keys > Key Mappings > Presets

# folders
mkdir ~/fzf-history/
