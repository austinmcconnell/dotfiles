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

RBENV_ROOT="$XDG_DATA_HOME/rbenv"
PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"

mkdir -p "$RBENV_ROOT"
mkdir -p "$RBENV_ROOT/plugins"
mkdir -p "$XDG_CONFIG_HOME/rubocop"

ln -sfv "$DOTFILES_DIR/etc/ruby/default-gems" "$RBENV_ROOT/default-gems"
ln -sfv "$DOTFILES_DIR/etc/ruby/rubocop.yml" "$XDG_CONFIG_HOME/rubocop/config.yml"

REPO_DIR="$RBENV_ROOT/plugins/rbenv-default-gems"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/rbenv/rbenv-default-gems.git "$REPO_DIR"
fi

REPO_DIR="$RBENV_ROOT/plugins/rbenv-update"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/rkh/rbenv-update.git "$REPO_DIR"
fi

rbenv install --skip-existing "${DEFAULT_RUBY_VERSION}"
rbenv global "${DEFAULT_RUBY_VERSION}"

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash
