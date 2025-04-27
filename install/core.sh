#!/usr/bin/env bash

# ---------------------------------------------------------------
# Core installation script
# This script installs the core functionality that is required
# regardless of user preferences
# ---------------------------------------------------------------

echo "Installing core components..."

# Ensure the config directory exists
mkdir -p "$DOTFILES_DIR/etc/core"

# Install yq for YAML parsing if not already installed
if ! is-executable yq; then
    echo "Installing yq for configuration management..."
    if is-macos; then
        brew install yq
    elif is-debian; then
        sudo apt-get update && sudo apt-get install -y yq
    else
        echo "Please install yq manually: https://github.com/mikefarah/yq"
    fi
fi

# Create user config directory if it doesn't exist
mkdir -p "$XDG_CONFIG_HOME/dotfiles"

# Initialize user configuration if it doesn't exist
if [ ! -f "$XDG_CONFIG_HOME/dotfiles/config.yaml" ]; then
    # Create initial user configuration with selected profile
    cat >"$XDG_CONFIG_HOME/dotfiles/config.yaml" <<EOF
# User configuration for dotfiles
# This file overrides the core configuration

# Selected profile (default, work, minimal)
profile: ${SELECTED_PROFILE:-default}

# Override specific module settings
modules:
  # Example: Disable a module
  # cloud:
  #   enabled: false

  # Example: Enable only specific components
  # development:
  #   enabled: true
  #   components:
  #     - git
  #     - python
EOF
fi

echo "Core components installed successfully"
