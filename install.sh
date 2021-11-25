#!/bin/bash

# tmux 3.1c
# vim latest tag

# make vim folders
mkdir $HOME/.vim/
mkdir $HOME/.vim/colors/
mkdir $HOME/.vim/autoload/
mkdir $HOME/vim/tmp/swap/

# copy vim items to their folders
ln -s $HOME/.vim/plugged/onedark.vim/colors/onedark.vim $HOME/.vim/colors/onedark.vim
ln -s $HOME/.vim/plugged/onedark.vim/autoload/onedark.vim $HOME/.vim/autoload/onedark.vim

# ripgrep
# fd
# Makre sure to enable natural text editing on iTerm
# Prefs > Profiles > Keys > Key Mappings > Presets

# folders
mkdir ~/fzf-history/
