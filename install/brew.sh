#!/bin/bash

set -euo pipefail

BREW_INSTALLED_FORMULAE=""
BREW_INSTALLED_CASKS=""
BREW_OUTDATED_FORMULAE=""
BREW_OUTDATED_CASKS=""
BREW_TAPS=""
CACHE_INITIALIZED=false

init_brew_cache() {
    echo "Initializing brew cache..."
    BREW_INSTALLED_FORMULAE=$(brew list --formula 2>/dev/null)
    BREW_INSTALLED_CASKS=$(brew list --cask 2>/dev/null)
    BREW_OUTDATED_FORMULAE=$(brew outdated --formula 2>/dev/null)
    BREW_OUTDATED_CASKS=$(brew outdated --cask 2>/dev/null)
    BREW_TAPS=$(brew tap)
    CACHE_INITIALIZED=true
}

is_package_installed() {
    local package=$1
    local package_type=${2:-formula}

    if [[ "$package_type" == "formula" ]]; then
        echo "$BREW_INSTALLED_FORMULAE" | grep -q "^$package\$"
    else
        echo "$BREW_INSTALLED_CASKS" | grep -q "^$package\$"
    fi
}

is_package_outdated() {
    local package=$1
    local package_type=${2:-formula}

    if [[ "$package_type" == "formula" ]]; then
        echo "$BREW_OUTDATED_FORMULAE" | grep -q "^$package\$"
    else
        echo "$BREW_OUTDATED_CASKS" | grep -q "^$package\$"
    fi
}

install_if_needed() {
    local package=$1
    local package_type=${2:-formula}

    if [[ "$CACHE_INITIALIZED" != "true" ]]; then
        init_brew_cache
    fi

    if ! is_package_installed "$package" "$package_type"; then
        echo "Installing $package ($package_type)..."
        if [[ "$package_type" == "cask" ]]; then
            brew install --cask "$package"
        else
            brew install --formula "$package"
        fi
        init_brew_cache
    elif is_package_outdated "$package" "$package_type"; then
        echo "Updating $package ($package_type)..."
        if [[ "$package_type" == "cask" ]]; then
            brew upgrade --cask "$package"
        else
            brew upgrade --formula "$package"
        fi
        init_brew_cache
    else
        echo "$package ($package_type) is already installed and up to date"
    fi
}

tap_if_needed() {
    local tap=$1

    if [[ "$CACHE_INITIALIZED" != "true" ]]; then
        init_brew_cache
    fi

    if ! echo "$BREW_TAPS" | grep -q "^$tap\$"; then
        echo "Tapping $tap..."
        brew tap "$tap"
        init_tap_cache
    else
        echo "Tap $tap already exists"
    fi
}

if is-executable brew; then
    print_header "Installing brew formulas and casks"
else
    if is-macos; then
        print_header "Installing Homebrew"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        print_header "Skipping Homebrew installation: Not macOS"
        return
    fi
fi

mkdir -p "$XDG_CONFIG_HOME/bat"
mkdir -p "$XDG_CONFIG_HOME/fd"
mkdir -p "$XDG_CONFIG_HOME/httpie"

ln -sfv "$DOTFILES_DIR/etc/misc/hadolint.yaml" "$XDG_CONFIG_HOME"
ln -sfv "$DOTFILES_DIR/etc/misc/shellcheckrc" "$XDG_CONFIG_HOME/shellcheckrc"
ln -sfv "$DOTFILES_DIR/etc/fd/ignore" "$XDG_CONFIG_HOME/fd/ignore"
ln -sfv "$DOTFILES_DIR/etc/httpie/config.json" "$XDG_CONFIG_HOME/httpie/config.json"
ln -sfv "$DOTFILES_DIR/etc/bat/config" "$XDG_CONFIG_HOME/bat/config"
ln -sfv "$DOTFILES_DIR/etc/sublime-text/Package Control.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
ln -sfv "$DOTFILES_DIR/etc/sublime-text/Preferences.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
ln -sfv "$DOTFILES_DIR/etc/sublime-text/Python.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
ln -sfv "$DOTFILES_DIR/etc/sublime-text/SublimeLinter.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
if is-macos; then
    ln -sfv "$DOTFILES_DIR/etc/sublime-text/Default (OSX).sublime-keymap" "$HOME/Library/Application Support/Sublime Text/Packages/User"
fi

print_header "Initializing brew cache"
init_brew_cache

print_header "Adding taps"
tap_if_needed "derailed/k9s"
tap_if_needed "heroku/brew"
tap_if_needed "yleisradio/terraforms"
tap_if_needed "zunit-zsh/zunit"

print_header "Installing formulas"
install_if_needed "autoenv" "formula"
install_if_needed "bash" "formula"
install_if_needed "bat" "formula"
install_if_needed "blueutil" "formula"
install_if_needed "ccache" "formula"
install_if_needed "chtf" "formula"
install_if_needed "coreutils" "formula"
install_if_needed "dive" "formula"
install_if_needed "dockutil" "formula"
install_if_needed "fd" "formula"
install_if_needed "findutils" "formula"
install_if_needed "fzf" "formula"
install_if_needed "git" "formula"
install_if_needed "git-delta" "formula"
install_if_needed "go" "formula"
install_if_needed "grep" "formula"
install_if_needed "hadolint" "formula"
install_if_needed "helm" "formula"
install_if_needed "httpie" "formula"
install_if_needed "jq" "formula"
install_if_needed "k9s" "formula"
install_if_needed "kubernetes-cli" "formula"
install_if_needed "mas" "formula"
install_if_needed "nano" "formula"
install_if_needed "openssl@3" "formula" # Used for compiling (e.g. pyenv building python versions from source)
install_if_needed "shellcheck" "formula"
install_if_needed "shfmt" "formula"
install_if_needed "ssh-copy-id" "formula"
install_if_needed "stern" "formula"
install_if_needed "terraform" "formula"
install_if_needed "tree" "formula"
install_if_needed "trivy" "formula"
install_if_needed "unar" "formula"
install_if_needed "vals" "formula"
install_if_needed "wget" "formula"
install_if_needed "wifi-password" "formula"
install_if_needed "yamllint" "formula"
install_if_needed "yq" "formula"
install_if_needed "zlib" "formula" # Used for compiling (e.g. pyenv building python versions from source)
install_if_needed "zunit" "formula"

# Install cloud cli tools
install_if_needed "awscli" "formula"

print_header "Installing casks"
install_if_needed "alfred" "cask"
install_if_needed "backuploupe" "cask"
install_if_needed "bartender" "cask"
install_if_needed "bluesnooze" "cask"
install_if_needed "calibre" "cask"
install_if_needed "docker" "cask"
install_if_needed "evernote" "cask"
install_if_needed "flux" "cask"
install_if_needed "firefox" "cask"
install_if_needed "gpg-suite" "cask"
install_if_needed "hazel" "cask"
install_if_needed "iterm2" "cask"
install_if_needed "keepingyouawake" "cask"
install_if_needed "monitorcontrol" "cask"
install_if_needed "multipass" "cask"
install_if_needed "obsidian" "cask"
install_if_needed "openlens" "cask"
install_if_needed "oversight" "cask"
install_if_needed "postico" "cask"
install_if_needed "postman" "cask"
install_if_needed "rectangle" "cask"
install_if_needed "silicon" "cask"
install_if_needed "slack" "cask"
install_if_needed "spotify" "cask"
install_if_needed "sublime-text" "cask"
install_if_needed "tableplus" "cask"
install_if_needed "the-unarchiver" "cask"
install_if_needed "vagrant" "cask"
install_if_needed "via" "cask"
install_if_needed "viscosity" "cask"
install_if_needed "visual-studio-code" "cask"
install_if_needed "zoom" "cask"

print_header "Installing fonts"
install_if_needed "font-fira-code" "cask"
install_if_needed "font-meslo-lg-nerd-font" "cask"
install_if_needed "font-fira-code-nerd-font" "cask"
install_if_needed "font-hack-nerd-font" "cask"
install_if_needed "font-inconsolata-nerd-font" "cask"
install_if_needed "font-sauce-code-pro-nerd-font" "cask"

print_header "Adding local TLS Certificate Authority"
install_if_needed "mkcert" "formula"
install_if_needed "nss" "formula"
mkcert -install

print_header "Running brew doctor"
brew doctor

# Add helm charts repository
print_header "Adding helm charts repositories"
helm repo add stable https://charts.helm.sh/stable

# Add brew installed bash as an allowed shell
print_header "Adding brew installed bash as an allowed shell"
grep "$(which bash)" /etc/shells &>/dev/null || sudo zsh -c "echo $(which bash) >> /etc/shells"
