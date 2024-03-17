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

RBENV_DIR=$(rbenv root)

mkdir -p "$XDG_CONFIG_HOME/rubocop"
mkdir -p "$RBENV_DIR/plugins"

ln -sfv "$DOTFILES_DIR/etc/ruby/default-gems" "$RBENV_DIR/default-gems"
ln -sfv "$DOTFILES_DIR/etc/ruby/rubocop.yml" "$XDG_CONFIG_HOME/rubocop/config.yml"

REPO_DIR="$HOME/.repositories/rbenv-default-gems"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/rbenv/rbenv-default-gems.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$RBENV_DIR/plugins/rbenv-default-gems"
fi

rbenv install --skip-existing "${DEFAULT_RUBY_VERSION}"
rbenv global "${DEFAULT_RUBY_VERSION}"

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash
