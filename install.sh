#!/usr/bin/env bash

# ---------------------------------------------------------------
# Main installation script for dotfiles
# This script coordinates the entire installation process by:
# 1. Setting up environment variables and directories
# 2. Installing core components and configuration system
# 3. Running individual installation scripts based on user configuration
# ---------------------------------------------------------------

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_EXTRA_DIR="$HOME/.extra" # Directory for machine-specific configurations
XDG_CONFIG_HOME="$HOME/.config"   # XDG standard configuration directory

# Make utilities available by adding bin directory to PATH
PATH="$DOTFILES_DIR/bin:$PATH"

# Update dotfiles repository itself first if it's a git repository
if is-executable git -a -d "$DOTFILES_DIR/.git"; then
    git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin main
fi

# Create necessary directories:
# - XDG_CONFIG_HOME: Standard location for application configs
# - ~/.repositories: For external git repositories
# - ~/.extra: For machine-specific configurations not tracked by git
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p ~/.repositories
mkdir -p "$HOME/.extra"

# Prompt user to select a profile
select_profile() {
    local profile
    while true; do
        read -r -p "Enter profile name [default]: " profile
        profile=${profile:-default}

        # Check if profile is valid (we can't use config-manager yet as it's not installed)
        if [ "$profile" = "default" ] || [ "$profile" = "work" ] || [ "$profile" = "minimal" ]; then
            echo "$profile"
            break
        else
            echo "Invalid profile. Please choose from: default, work, minimal"
        fi
    done
}

# Select profile if config doesn't exist
SELECTED_PROFILE="default"
if [ ! -f "$HOME/.extra/config.yaml" ]; then
    # Display profile selection prompt
    echo "Please select a profile for your dotfiles installation:"
    echo "-----------------------------------------------------"
    echo "default  - Standard configuration for personal use"
    echo "work     - Configuration optimized for work environment"
    echo "minimal  - Lightweight configuration for servers or minimal setups"
    echo "-----------------------------------------------------"

    SELECTED_PROFILE=$(select_profile)
fi

# Install core components first (required for configuration system)
export SELECTED_PROFILE
. "$DOTFILES_DIR/install/core.sh"

# Set the selected profile in the configuration
"$DOTFILES_DIR/bin/config-manager" profile "$SELECTED_PROFILE"

# Function to conditionally load a module based on configuration
load_module_if_enabled() {
    local module="$1"
    local script="$2"

    if "$DOTFILES_DIR/bin/config-manager" is-enabled "$module" | grep -q "enabled"; then
        echo "Loading module: $module"
        # shellcheck source=./install/git.sh source=./install/zsh.sh source=./install/brew.sh source=./install/apt.sh source=./install/python.sh source=./install/node.sh source=./install/vim.sh source=./install/ruby.sh source=./install/scripts.sh source=./install/ssh.sh source=./install/amazon-q.sh source=./macos/apps.sh
        . "$script"
    else
        echo "Skipping module: $module (disabled in configuration)"
    fi
}

# Install and configure components based on user configuration:
# 1. Core tools (git, zsh)
# 2. Package managers (brew, apt)
# 3. Programming languages and environments
# 4. Applications and utilities
# 5. System configurations

# Shell environment
load_module_if_enabled "shell" "$DOTFILES_DIR/install/zsh.sh"

# Development tools
load_module_if_enabled "development" "$DOTFILES_DIR/install/git.sh"
load_module_if_enabled "development" "$DOTFILES_DIR/install/python.sh"
load_module_if_enabled "development" "$DOTFILES_DIR/install/node.sh"
load_module_if_enabled "development" "$DOTFILES_DIR/install/vim.sh"
load_module_if_enabled "development" "$DOTFILES_DIR/install/ruby.sh"

# Package managers
if is-macos; then
    load_module_if_enabled "package_managers" "$DOTFILES_DIR/install/brew.sh"
    load_module_if_enabled "applications" "$DOTFILES_DIR/macos/apps.sh"
elif is-debian; then
    load_module_if_enabled "package_managers" "$DOTFILES_DIR/install/apt.sh"
fi

# System configuration
load_module_if_enabled "system" "$DOTFILES_DIR/install/ssh.sh"

# Utility scripts
load_module_if_enabled "development" "$DOTFILES_DIR/install/scripts.sh"

# AI tools
load_module_if_enabled "ai" "$DOTFILES_DIR/install/amazon-q.sh"

# Create .hushlogin to disable the login message
touch ~/.hushlogin

# Run tests to verify the installation
if is-executable zunit; then zunit; else echo "Skipped: tests (missing: zunit)"; fi
