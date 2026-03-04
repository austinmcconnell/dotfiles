# Complete Example Scripts

## Example 1: Simple Tool Installation

**File:** `install/fzf.sh`

```bash
#!/bin/bash

# ---------------------------------------------------------------
# FZF Installation Script
# This script:
# 1. Installs fzf via Homebrew
# 2. Links fzf configuration
# 3. Sets up shell integration
# ---------------------------------------------------------------

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

print_header "Installing FZF"

# Initialize Homebrew cache
init_brew_cache

# Install fzf
install_if_needed "fzf"

# Create config directory
mkdir -p "$HOME/.config/fzf"

# Link configuration
ln -sfv "$DOTFILES_DIR/etc/fzf/fzf.zsh" "$HOME/.config/fzf/fzf.zsh"

# Install shell integration
if command -v fzf &>/dev/null; then
    echo "Setting up fzf shell integration..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
else
    echo "⚠️  fzf not found, skipping shell integration"
fi

echo "✅ FZF installation complete"
```

---

## Example 2: Multiple Packages

**File:** `install/development-tools.sh`

```bash
#!/bin/bash

# ---------------------------------------------------------------
# Development Tools Installation Script
# This script:
# 1. Installs core development tools
# 2. Installs language-specific tools
# 3. Installs version managers
# ---------------------------------------------------------------

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

print_header "Installing Development Tools"

# Initialize Homebrew cache
init_brew_cache

# Core tools
CORE_TOOLS=(
    "git"
    "vim"
    "tmux"
    "fzf"
    "ripgrep"
    "fd"
    "bat"
    "jq"
)

echo "Installing core tools..."
for tool in "${CORE_TOOLS[@]}"; do
    install_if_needed "$tool"
done

# Language tools
LANGUAGE_TOOLS=(
    "python"
    "node"
    "go"
    "rust"
)

echo "Installing language tools..."
for tool in "${LANGUAGE_TOOLS[@]}"; do
    install_if_needed "$tool"
done

# Version managers
VERSION_MANAGERS=(
    "pyenv"
    "rbenv"
    "nvm"
)

echo "Installing version managers..."
for tool in "${VERSION_MANAGERS[@]}"; do
    install_if_needed "$tool"
done

echo "✅ Development tools installation complete"
```

---

## Example 3: Cask Applications

**File:** `install/applications.sh`

```bash
#!/bin/bash

# ---------------------------------------------------------------
# Applications Installation Script
# This script:
# 1. Installs GUI applications via Homebrew Cask
# 2. Separates work and personal applications
# ---------------------------------------------------------------

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

print_header "Installing Applications"

# Initialize Homebrew cache
init_brew_cache

# Common applications (both work and personal)
COMMON_APPS=(
    "visual-studio-code"
    "iterm2"
    "docker"
    "postman"
)

echo "Installing common applications..."
for app in "${COMMON_APPS[@]}"; do
    install_if_needed "$app" "cask" "both"
done

# Work-only applications
WORK_APPS=(
    "slack"
    "zoom"
    "microsoft-teams"
)

echo "Installing work applications..."
for app in "${WORK_APPS[@]}"; do
    install_if_needed "$app" "cask" "work"
done

# Personal-only applications
PERSONAL_APPS=(
    "spotify"
    "discord"
    "vlc"
)

echo "Installing personal applications..."
for app in "${PERSONAL_APPS[@]}"; do
    install_if_needed "$app" "cask" "personal"
done

echo "✅ Applications installation complete"
```

---

## Example 4: Configuration Linking

**File:** `install/zsh.sh`

```bash
#!/bin/bash

# ---------------------------------------------------------------
# Zsh Installation Script
# This script:
# 1. Installs Zsh via Homebrew
# 2. Links Zsh configuration files
# 3. Sets Zsh as default shell
# ---------------------------------------------------------------

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

print_header "Installing Zsh"

# Initialize Homebrew cache
init_brew_cache

# Install Zsh
install_if_needed "zsh"

# Create config directory
mkdir -p "$HOME/.config/zsh"

# Link configuration files
ZSH_CONFIG_DIR="$DOTFILES_DIR/etc/zsh"

if [ -d "$ZSH_CONFIG_DIR" ]; then
    echo "Linking Zsh configuration files..."

    # Link main config files
    ln -sfv "$ZSH_CONFIG_DIR/.zshrc" "$HOME/.zshrc"
    ln -sfv "$ZSH_CONFIG_DIR/.zshenv" "$HOME/.zshenv"
    ln -sfv "$ZSH_CONFIG_DIR/.zprofile" "$HOME/.zprofile"
    ln -sfv "$ZSH_CONFIG_DIR/.zlogin" "$HOME/.zlogin"

    # Link config directory
    ln -sfv "$ZSH_CONFIG_DIR" "$HOME/.config/zsh"

    echo "✓ Zsh configuration linked"
else
    echo "⚠️  Zsh config directory not found: $ZSH_CONFIG_DIR"
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
    echo "✓ Default shell changed to Zsh"
else
    echo "✓ Zsh is already the default shell"
fi

echo "✅ Zsh installation complete"
```

---

## Example 5: Platform-Specific Installation

**File:** `install/platform-tools.sh`

```bash
#!/bin/bash

# ---------------------------------------------------------------
# Platform-Specific Tools Installation Script
# This script:
# 1. Installs macOS-specific tools
# 2. Installs Linux-specific tools
# ---------------------------------------------------------------

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

print_header "Installing Platform-Specific Tools"

# Initialize Homebrew cache
init_brew_cache

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Installing macOS-specific tools..."

    # macOS tools
    install_if_needed "mas"  # Mac App Store CLI
    install_if_needed "m-cli"  # macOS management CLI

    # macOS casks
    install_if_needed "rectangle" "cask"  # Window management
    install_if_needed "alfred" "cask"  # Launcher

    echo "✓ macOS tools installed"

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Installing Linux-specific tools..."

    # Linux tools (using apt)
    if command -v apt-get &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y \
            build-essential \
            curl \
            wget \
            git
    fi

    echo "✓ Linux tools installed"
else
    echo "⚠️  Unknown platform: $OSTYPE"
fi

echo "✅ Platform-specific tools installation complete"
```

---

## Example 6: Tap and Font Installation

**File:** `install/fonts.sh`

```bash
#!/bin/bash

# ---------------------------------------------------------------
# Fonts Installation Script
# This script:
# 1. Adds Homebrew font tap
# 2. Installs programming fonts
# ---------------------------------------------------------------

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

print_header "Installing Fonts"

# Initialize Homebrew cache
init_brew_cache

# Add font tap
tap_if_needed "homebrew/cask-fonts"

# Programming fonts
FONTS=(
    "font-fira-code"
    "font-jetbrains-mono"
    "font-source-code-pro"
    "font-hack"
)

echo "Installing programming fonts..."
for font in "${FONTS[@]}"; do
    install_if_needed "$font" "cask"
done

echo "✅ Fonts installation complete"
```

---

## Example 7: Conditional Setup

**File:** `install/docker.sh`

```bash
#!/bin/bash

# ---------------------------------------------------------------
# Docker Installation Script
# This script:
# 1. Installs Docker Desktop
# 2. Configures Docker settings
# 3. Installs Docker Compose
# ---------------------------------------------------------------

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

print_header "Installing Docker"

# Initialize Homebrew cache
init_brew_cache

# Install Docker Desktop
install_if_needed "docker" "cask"

# Wait for Docker to be available
if command -v docker &>/dev/null; then
    echo "✓ Docker is available"

    # Install Docker Compose (if not included)
    if ! docker compose version &>/dev/null; then
        echo "Installing Docker Compose..."
        install_if_needed "docker-compose"
    else
        echo "✓ Docker Compose is available"
    fi

    # Create Docker config directory
    mkdir -p "$HOME/.docker"

    # Link Docker config if exists
    if [ -f "$DOTFILES_DIR/etc/docker/config.json" ]; then
        ln -sfv "$DOTFILES_DIR/etc/docker/config.json" "$HOME/.docker/config.json"
        echo "✓ Docker config linked"
    fi
else
    echo "⚠️  Docker not found, skipping additional setup"
fi

echo "✅ Docker installation complete"
```

---

## Example 8: Error Handling

**File:** `install/optional-tool.sh`

```bash
#!/bin/bash

# ---------------------------------------------------------------
# Optional Tool Installation Script
# This script demonstrates error handling for optional components
# ---------------------------------------------------------------

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

print_header "Installing Optional Tool"

# Initialize Homebrew cache
init_brew_cache

# Install main tool
install_if_needed "main-tool"

# Optional component (don't fail if unavailable)
if install_if_needed "optional-component" 2>/dev/null; then
    echo "✓ Optional component installed"
else
    echo "⚠️  Optional component not available, skipping"
fi

# Conditional setup based on tool availability
if command -v main-tool &>/dev/null; then
    echo "Configuring main-tool..."

    # Configuration steps
    mkdir -p "$HOME/.config/main-tool"
    ln -sfv "$DOTFILES_DIR/etc/main-tool/config" "$HOME/.config/main-tool/config"

    echo "✓ main-tool configured"
else
    echo "⚠️  main-tool not found, skipping configuration"
fi

echo "✅ Optional tool installation complete"
```

---

## Common Patterns Summary

**Basic installation:**

```bash
init_brew_cache
install_if_needed "package"
```

**Multiple packages:**

```bash
for package in "${PACKAGES[@]}"; do
    install_if_needed "$package"
done
```

**Cask installation:**

```bash
install_if_needed "app-name" "cask"
```

**Work/personal split:**

```bash
install_if_needed "slack" "cask" "work"
install_if_needed "spotify" "cask" "personal"
```

**Configuration linking:**

```bash
mkdir -p "$HOME/.config/tool"
ln -sfv "$DOTFILES_DIR/etc/tool/config" "$HOME/.config/tool/config"
```

**Conditional setup:**

```bash
if command -v tool &>/dev/null; then
    # Setup steps
fi
```

**Platform-specific:**

```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
fi
```
