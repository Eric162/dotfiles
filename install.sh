#!/bin/bash

# Prerequisites
# brew, node, vim

ln -sf "$(pwd)/.gitconfig" $HOME/
ln -sf "$(pwd)/.gitconfig-personal" $HOME/
ln -sf "$(pwd)/.gitconfig" $HOME/
ln -sf "$(pwd)/.vimrc" $HOME/
ln -sf "$(pwd)/.tmux.conf" $HOME/
ln -sf "$(pwd)/.bash_profile" $HOME/
ln -sf "$(pwd)/.zshenv" $HOME/

# tmux 3.1c
# vim latest tag

# make vim folders
mkdir $HOME/.vim/
mkdir $HOME/.vim/colors/
mkdir $HOME/.vim/autoload/
mkdir $HOME/.vim/tmp/swap/

# open vim to PlugInstall

# copy vim items to their folders
ln -s $HOME/.vim/plugged/onedark.vim/colors/onedark.vim $HOME/.vim/colors/onedark.vim
ln -s $HOME/.vim/plugged/onedark.vim/autoload/onedark.vim $HOME/.vim/autoload/onedark.vim

# ripgrep and fd
brew install rg fd
# Make sure to enable natural text editing on iTerm
# Prefs > Profiles > Keys > Key Mappings > Presets

# folders
mkdir ~/fzf-history/
