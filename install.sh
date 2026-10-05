#!/usr/bin/env bash

# ---------------------------------------------------------------
# Main installation script for dotfiles
# This script coordinates the entire installation process by:
# 1. Setting up environment variables and directories
# 2. Determining if this is a work or personal computer
# 3. Running individual installation scripts for different components
# ---------------------------------------------------------------

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR AI_DOTFILES_DIR
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Root of the AI tooling config. Defaults to DOTFILES_DIR while colocated; a
# standalone extraction sets this to its own root before sourcing the AI scripts.
AI_DOTFILES_DIR="${AI_DOTFILES_DIR:-$DOTFILES_DIR}"
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
# - ~/.extra: For machine-specific configurations not tracked by git
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$HOME/.extra"

# Check if .env file exists and if IS_WORK_COMPUTER is already set
# This determines whether this is a work or personal computer, which affects:
# - Which packages are installed
# - Which configurations are applied
# - Default settings for various tools
if [ ! -f "$HOME/.extra/.env" ] || ! grep -q "^export IS_WORK_COMPUTER=" "$HOME/.extra/.env"; then
    while true; do
        read -r -p "Is this script being run on a work computer? (y/n): " yn
        case $yn in
        [Yy]*)
            echo "export IS_WORK_COMPUTER=1" >>"$HOME/.extra/.env"
            break
            ;;
        [Nn]*)
            echo "export IS_WORK_COMPUTER=0" >>"$HOME/.extra/.env"
            break
            ;;
        *)
            echo "Please answer yes (y) or no (n)."
            ;;
        esac
    done
fi

# Install and configure components in a specific order:
# 1. Core tools (git, zsh)
# 2. Package managers (brew, apt)
# 3. Programming languages and environments
# 4. Applications and utilities
# 5. System configurations
. "$DOTFILES_DIR/install/git.sh"            # Git configuration and aliases
. "$DOTFILES_DIR/install/zsh.sh"            # Zsh shell with antidote plugin manager
. "$DOTFILES_DIR/install/brew.sh"           # Homebrew packages (macOS)
. "$DOTFILES_DIR/macos/apps.sh"             # macOS applications
. "$DOTFILES_DIR/install/apt.sh"            # APT packages (Debian)
. "$DOTFILES_DIR/install/python.sh"         # Python with pyenv
. "$DOTFILES_DIR/install/node.sh"           # Node.js with nvm
. "$DOTFILES_DIR/install/go.sh"             # Go with development tools
. "$DOTFILES_DIR/install/vim.sh"            # Vim with vim-plug
. "$DOTFILES_DIR/install/ruby.sh"           # Ruby with rbenv
. "$DOTFILES_DIR/install/ssh.sh"            # SSH configuration
. "$DOTFILES_DIR/install/dircolors.sh"      # Dircolors themes
. "$DOTFILES_DIR/install/xdg-compliance.sh" # XDG compliance for CLI tools
. "$DOTFILES_DIR/install/sops.sh"           # SOPS + age secrets management
. "$DOTFILES_DIR/install/glow.sh"           # Glow markdown viewer
. "$DOTFILES_DIR/install/ghostty.sh"        # Ghostty terminal emulator (iTerm2 trial)
. "$DOTFILES_DIR/install/terraform.sh"      # Terraform with rc file
# AI tooling (agents, skills, steering, hooks + per-tool configs) lives in the
# standalone ai-dotfiles repo, a required dependency. Clone it if absent, then
# source its orchestrator with AI_DOTFILES_DIR pointed at it.
AI_DOTFILES_REPO="$HOME/.ai-dotfiles"
if [ ! -d "$AI_DOTFILES_REPO/.git" ] && is-executable git; then
    echo "Cloning ai-dotfiles..."
    git clone git@personal:austinmcconnell/ai-dotfiles.git "$AI_DOTFILES_REPO" ||
        echo "⚠️  Failed to clone ai-dotfiles"
fi

if [ -f "$AI_DOTFILES_REPO/install.sh" ]; then
    AI_DOTFILES_DIR="$AI_DOTFILES_REPO"
    . "$AI_DOTFILES_REPO/install.sh" # AI tooling via standalone ai-dotfiles repo
else
    echo "⚠️  ai-dotfiles repo unavailable at $AI_DOTFILES_REPO; skipping AI tooling" >&2
    echo "    Clone git@personal:austinmcconnell/ai-dotfiles.git and re-run install.sh" >&2
fi

# Create .hushlogin to disable the login message
touch ~/.hushlogin

# Run tests to verify the installation
if is-executable zunit; then zunit; else echo "Skipped: tests (missing: zunit)"; fi
