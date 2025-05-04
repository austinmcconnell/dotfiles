#!/bin/zsh
#
# 00-fpath.zsh - Configure function paths and autoload functions
#

# Add functions directory to fpath and autoload all functions
fpath=($DOTFILES_DIR/etc/zsh/functions $fpath)
autoload -Uz $DOTFILES_DIR/etc/zsh/functions/*
