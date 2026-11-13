#!/bin/bash

source "$DOTFILES_DIR/install/utils.sh"

if is-executable rbenv; then
    echo "**************************************************"
    echo "Configuring Ruby"
    echo "**************************************************"
    # Older ruby-build releases do not know newer Ruby versions
    if brew list --formula ruby-build >/dev/null 2>&1; then
        brew upgrade ruby-build
    fi
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
        sudo apt install -y autoconf bison build-essential libssl-dev libyaml-dev \
            libreadline-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev
        brew install rbenv ruby-build
    else
        echo "**************************************************"
        echo "Skipping Ruby installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

DEFAULT_RUBY_VERSION=4.0.9

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export RBENV_ROOT="$XDG_DATA_HOME/rbenv"
PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"

# Create XDG directories for Ruby-related tools
mkdir -p "$RBENV_ROOT"
mkdir -p "$RBENV_ROOT/plugins"
mkdir -p "$XDG_CONFIG_HOME/rubocop"
mkdir -p "$XDG_CONFIG_HOME/irb"
mkdir -p "$XDG_DATA_HOME/irb"
mkdir -p "$XDG_CONFIG_HOME/gem"
mkdir -p "$XDG_CONFIG_HOME/bundle"
mkdir -p "$XDG_CACHE_HOME/bundle"
mkdir -p "$XDG_DATA_HOME/bundle/plugin"
mkdir -p "$XDG_CONFIG_HOME/ruby-lsp"

# Link configuration files
link_and_verify "$DOTFILES_DIR/etc/ruby/default-gems" "$RBENV_ROOT/default-gems" || return 1
link_and_verify "$DOTFILES_DIR/etc/ruby/rubocop.yml" "$XDG_CONFIG_HOME/rubocop/config.yml" || return 1
link_and_verify "$DOTFILES_DIR/etc/ruby/irbrc" "$XDG_CONFIG_HOME/irb/irbrc" || return 1
link_and_verify "$DOTFILES_DIR/etc/ruby/gemrc" "$XDG_CONFIG_HOME/gem/gemrc" || return 1
link_and_verify "$DOTFILES_DIR/etc/ruby/bundle-config" "$XDG_CONFIG_HOME/bundle/config" || return 1

# Install rbenv plugins
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

# Install Ruby
rbenv install --skip-existing "${DEFAULT_RUBY_VERSION}" || return 1
rbenv global "${DEFAULT_RUBY_VERSION}"

# Ensure default gems are installed (rbenv-default-gems only runs
# during rbenv install, so gems added later would be missed)
xargs gem install <"$DOTFILES_DIR/etc/ruby/default-gems" || return 1
rbenv rehash
