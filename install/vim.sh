#!/bin/bash

source "$DOTFILES_DIR/install/utils.sh"

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
    brew install ctags
elif is-debian; then
    sudo apt update
    sudo apt install -y universal-ctags
fi

VIM_DIR="$HOME/.vim"

mkdir -p "$VIM_DIR"/spell
mkdir -p "$VIM_DIR"/undodir
mkdir -p "$XDG_CONFIG_HOME/yamllint/"
mkdir -p "$XDG_CONFIG_HOME/ripgrep"

mkdir -p "$VIM_DIR"
link_and_verify "$DOTFILES_DIR/etc/vim/after" "$VIM_DIR/after" || return 1
link_and_verify "$DOTFILES_DIR/etc/vim/plugin" "$VIM_DIR/plugin" || return 1
link_and_verify "$DOTFILES_DIR/etc/vim/syntax" "$VIM_DIR/syntax" || return 1
link_and_verify "$DOTFILES_DIR/etc/vim/filetype.vim" "$VIM_DIR/filetype.vim" || return 1
link_and_verify "$DOTFILES_DIR/etc/vim/.vimrc" "$VIM_DIR/vimrc" || return 1
link_and_verify "$DOTFILES_DIR/etc/vim/.ctags" "$HOME/.ctags" || return 1
link_and_verify "$DOTFILES_DIR/etc/yaml/yamllint" "$XDG_CONFIG_HOME/yamllint/config" || return 1
link_and_verify "$DOTFILES_DIR/etc/ripgrep/config" "$XDG_CONFIG_HOME/ripgrep/config" || return 1
