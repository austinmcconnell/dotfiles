#!/bin/bash

if is-executable rbenv; then
    echo "**************************************************"
    echo "Configuring Ruby"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Ruby"
        echo "**************************************************"
        brew install rbenv ruby-build
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Ruby"
        echo "**************************************************"
        sudo apt install rbenv
    else
        echo "**************************************************"
        echo "Skipping Ruby installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

DEFAULT_RUBY_VERSION=3.2.2

mkdir -p ~/.config/rubocop

ln -sfv "$DOTFILES_DIR/etc/ruby/rubocop.yml" ~/.config/rubocop/config.yml

rbenv install "${DEFAULT_RUBY_VERSION}"
rbenv global "${DEFAULT_RUBY_VERSION}"

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash
