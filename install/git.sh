#!/bin/bash

if is-executable git; then
    echo "**************************************************"
    echo "Configuring Git"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Git with brew"
        echo "**************************************************"
        brew install git
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Git with apt"
        echo "**************************************************"
        sudo apt install git
    else
        echo "**************************************************"
        echo "Skipping Git installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

GIT_CONFIG_DIR="$HOME/.config/git"

mkdir -p "$GIT_CONFIG_DIR"
mkdir -p "$GIT_CONFIG_DIR"/templates/hooks

ln -sfv "$DOTFILES_DIR/etc/git/config" "$GIT_CONFIG_DIR"
ln -sfv "$DOTFILES_DIR/etc/git/ignore" "$GIT_CONFIG_DIR"
ln -sfv "$DOTFILES_DIR/etc/git/hooks/pre-push" "$GIT_CONFIG_DIR"/templates/hooks/pre-push
ln -sfv "$DOTFILES_DIR/etc/git/config-uniteus" "$GIT_CONFIG_DIR"

if is-macos; then
    ln -sfv "$DOTFILES_DIR/etc/git/config-macos" "$GIT_CONFIG_DIR"
elif is-debian; then
    ln -sfv "$DOTFILES_DIR/etc/git/config-linux" "$GIT_CONFIG_DIR"
fi
