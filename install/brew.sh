#!/bin/bash

set -euo pipefail

# Source the utilities script
source "$DOTFILES_DIR/install/utils.sh"

# --- Install Homebrew ---
if is-executable brew; then
    print_section_header "Installing brew packages via Brewfile"
else
    if is-macos; then
        print_section_header "Installing Homebrew"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    elif is-debian; then
        print_section_header "Installing Homebrew on Linux"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add Homebrew to PATH for current session
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        print_section_header "Skipping Homebrew installation: Unsupported OS"
        return
    fi
fi

# --- Config directories and symlinks ---
mkdir -p "$XDG_CONFIG_HOME/bat"
mkdir -p "$XDG_CONFIG_HOME/dprint"
mkdir -p "$XDG_CONFIG_HOME/fd"
mkdir -p "$XDG_CONFIG_HOME/gh"
mkdir -p "$XDG_CONFIG_HOME/httpie"
mkdir -p "$XDG_CONFIG_HOME/rumdl"
mkdir -p "$XDG_CONFIG_HOME/vale"

ln -sfv "$DOTFILES_DIR/etc/misc/hadolint.yaml" "$XDG_CONFIG_HOME"
ln -sfv "$DOTFILES_DIR/etc/misc/shellcheckrc" "$XDG_CONFIG_HOME/shellcheckrc"
ln -sfv "$DOTFILES_DIR/etc/dprint/dprint.jsonc" "$XDG_CONFIG_HOME/dprint/dprint.jsonc"
ln -sfv "$DOTFILES_DIR/etc/vale/vale.ini" "$XDG_CONFIG_HOME/vale/vale.ini"
ln -sfv "$DOTFILES_DIR/etc/fd/ignore" "$XDG_CONFIG_HOME/fd/ignore"
ln -sfv "$DOTFILES_DIR/etc/gh/config.yml" "$XDG_CONFIG_HOME/gh/config.yml"
ln -sfv "$DOTFILES_DIR/etc/httpie/config.json" "$XDG_CONFIG_HOME/httpie/config.json"
ln -sfv "$DOTFILES_DIR/etc/rumdl/rumdl.toml" "$XDG_CONFIG_HOME/rumdl/rumdl.toml"
ln -sfv "$DOTFILES_DIR/etc/bat/config" "$XDG_CONFIG_HOME/bat/config"

# Sublime Text configuration
if is-macos; then
    SUBLIME_USER_DIR="$HOME/Library/Application Support/Sublime Text/Packages/User"
elif is-debian; then
    SUBLIME_USER_DIR="$XDG_CONFIG_HOME/sublime-text/Packages/User"
fi

if [ -n "$SUBLIME_USER_DIR" ]; then
    mkdir -p "$SUBLIME_USER_DIR"
    ln -sfv "$DOTFILES_DIR/etc/sublime-text/Fmt.sublime-settings" "$SUBLIME_USER_DIR"
    ln -sfv "$DOTFILES_DIR/etc/sublime-text/LanguageServers.sublime-settings" "$SUBLIME_USER_DIR"
    ln -sfv "$DOTFILES_DIR/etc/sublime-text/Package Control.sublime-settings" "$SUBLIME_USER_DIR"
    ln -sfv "$DOTFILES_DIR/etc/sublime-text/Preferences.sublime-settings" "$SUBLIME_USER_DIR"
    ln -sfv "$DOTFILES_DIR/etc/sublime-text/Python.sublime-settings" "$SUBLIME_USER_DIR"
    ln -sfv "$DOTFILES_DIR/etc/sublime-text/SublimeLinter.sublime-settings" "$SUBLIME_USER_DIR"
    ln -sfv "$DOTFILES_DIR/etc/sublime-text/lsp_library_installer.py" "$SUBLIME_USER_DIR"

    if is-macos; then
        ln -sfv "$DOTFILES_DIR/etc/sublime-text/Default (OSX).sublime-keymap" "$SUBLIME_USER_DIR"
    fi
fi

# --- Install packages from distributed Brewfiles ---
print_section_header "Running brew bundle"

if [ -f "$HOME/.extra/.env" ]; then
    source "$HOME/.extra/.env"
fi
export HOMEBREW_IS_WORK_COMPUTER="${IS_WORK_COMPUTER:-0}"

brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock --no-upgrade

# --- Post-install steps ---
print_section_header "Running post-install configuration"

if is-macos; then
    mkcert -install
    brew doctor || true
fi

# Add helm charts repository
echo "Adding helm charts repositories"
helm repo add stable https://charts.helm.sh/stable 2>/dev/null || true

# Download vale style packages
echo "Downloading vale style packages"
VALE_CONFIG_PATH="$XDG_CONFIG_HOME/vale/vale.ini" vale sync

# Add brew installed bash as an allowed shell
echo "Adding brew installed bash as an allowed shell"
grep "$(which bash)" /etc/shells &>/dev/null || sudo zsh -c "echo $(which bash) >> /etc/shells"
