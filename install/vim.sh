#!/bin/bash

if is-executable vim; then
    echo "**************************************************"
    echo "Configuring Vim"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Vim"
        echo "**************************************************"
        brew install vim
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Vim"
        echo "**************************************************"
        sudo apt update
        sudo apt install -y vim
    else
        echo "**************************************************"
        echo "Skipping Vim installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

if is-macos; then
    brew install ctags the_silver_searcher
elif is-debian; then
    sudo apt update
    sudo apt install -y ctags silversearcher-ag
fi

VIM_DIR="$HOME/.vim"

mkdir -p "$VIM_DIR"/spell
mkdir -p "$VIM_DIR"/undodir
mkdir -p "$XDG_CONFIG_HOME/yamllint/"

ln -sfv "$DOTFILES_DIR/etc/vim/after" "$VIM_DIR"
ln -sfv "$DOTFILES_DIR/etc/vim/plugin" "$VIM_DIR"
ln -sfv "$DOTFILES_DIR/etc/vim/syntax" "$VIM_DIR"
ln -sfv "$DOTFILES_DIR/etc/vim/filetype.vim" "$VIM_DIR"
ln -sfv "$DOTFILES_DIR/etc/vim/.vimrc" "$VIM_DIR/vimrc"
ln -sfv "$DOTFILES_DIR/etc/vim/.ctags" ~
ln -sfv "$DOTFILES_DIR/etc/ag/.agignore" ~
ln -sfv "$DOTFILES_DIR/etc/yaml/yamllint" "$XDG_CONFIG_HOME/yamllint/config"
