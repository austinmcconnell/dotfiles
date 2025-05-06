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

# Create XDG directories for Ruby-related tools
mkdir -p "$RBENV_ROOT"
mkdir -p "$RBENV_ROOT/plugins"
mkdir -p "$XDG_CONFIG_HOME/rubocop"
mkdir -p "$XDG_CONFIG_HOME/irb"
mkdir -p "$XDG_DATA_HOME/irb"
mkdir -p "$XDG_DATA_HOME/gem"
mkdir -p "$XDG_CONFIG_HOME/gem"
mkdir -p "$XDG_CACHE_HOME/gem/specs"
mkdir -p "$XDG_CONFIG_HOME/bundle"
mkdir -p "$XDG_CACHE_HOME/bundle"
mkdir -p "$XDG_DATA_HOME/bundle/plugin"
mkdir -p "$XDG_CONFIG_HOME/ruby-lsp"

# Migrate IRB history files
if [[ -f "$HOME/.irb_history" ]]; then
    echo "Moving existing .irb_history file to XDG_DATA_HOME/irb/history"
    mv "$HOME/.irb_history" "$XDG_DATA_HOME/irb/history"
fi

if [[ -f "$HOME/.irb-history" ]]; then
    echo "Moving existing .irb-history file to XDG_DATA_HOME/irb/history"
    mv "$HOME/.irb-history" "$XDG_DATA_HOME/irb/history"
fi

# Migrate RubyGems files
if [[ -d "$HOME/.gem" ]]; then
    echo "Moving existing .gem directory contents to XDG_DATA_HOME/gem"
    if [[ -d "$HOME/.gem/specs" ]]; then
        cp -r "$HOME/.gem/specs/"* "$XDG_CACHE_HOME/gem/specs/"
    fi
    # Copy any other important gem files/directories
    if [[ -d "$HOME/.gem/ruby" ]]; then
        mkdir -p "$XDG_DATA_HOME/gem/ruby"
        cp -r "$HOME/.gem/ruby/"* "$XDG_DATA_HOME/gem/ruby/"
    fi
    rm -rf "$HOME/.gem"
fi

# Migrate Bundler files
if [[ -d "$HOME/.bundle" ]]; then
    echo "Moving existing .bundle directory contents to XDG locations"
    if [[ -f "$HOME/.bundle/config" ]]; then
        cp "$HOME/.bundle/config" "$XDG_CONFIG_HOME/bundle/config"
    fi
    if [[ -d "$HOME/.bundle/cache" ]]; then
        cp -r "$HOME/.bundle/cache/"* "$XDG_CACHE_HOME/bundle/"
    fi
    if [[ -d "$HOME/.bundle/plugin" ]]; then
        cp -r "$HOME/.bundle/plugin/"* "$XDG_DATA_HOME/bundle/plugin/"
    fi
    rm -rf "$HOME/.bundle"
fi

# Migrate Ruby-LSP files
if [[ -d "$HOME/.ruby-lsp" ]]; then
    echo "Moving existing .ruby-lsp directory to XDG_CONFIG_HOME/ruby-lsp"
    cp -r "$HOME/.ruby-lsp/"* "$XDG_CONFIG_HOME/ruby-lsp/"
    rm -rf "$HOME/.ruby-lsp"
fi

# Link configuration files
ln -sfv "$DOTFILES_DIR/etc/ruby/default-gems" "$RBENV_ROOT/default-gems"
ln -sfv "$DOTFILES_DIR/etc/ruby/rubocop.yml" "$XDG_CONFIG_HOME/rubocop/config.yml"
ln -sfv "$DOTFILES_DIR/etc/ruby/irbrc" "$XDG_CONFIG_HOME/irb/irbrc"
ln -sfv "$DOTFILES_DIR/etc/ruby/gemrc" "$XDG_CONFIG_HOME/gem/gemrc"
ln -sfv "$DOTFILES_DIR/etc/ruby/bundle-config" "$XDG_CONFIG_HOME/bundle/config"

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
rbenv install --skip-existing "${DEFAULT_RUBY_VERSION}"
rbenv global "${DEFAULT_RUBY_VERSION}"

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash
