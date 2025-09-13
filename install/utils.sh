#!/bin/bash

# Common utility functions for installation scripts

BREW_INSTALLED_FORMULAE=""
BREW_INSTALLED_CASKS=""
BREW_OUTDATED_FORMULAE=""
BREW_OUTDATED_CASKS=""
BREW_TAPS=""
CACHE_DIR="$HOME/.cache/dotfiles"
CACHE_FILE="$CACHE_DIR/brew_cache"
CACHE_TTL=300 # 5 minutes

init_brew_cache() {
    mkdir -p "$CACHE_DIR"

    # Check if cache exists and is fresh
    if [[ -f "$CACHE_FILE" ]]; then
        local cache_mtime
        cache_mtime=$(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
        local cache_age
        cache_age=$(($(date +%s) - cache_mtime))
        if [[ $cache_age -lt $CACHE_TTL ]]; then
            # shellcheck source=/dev/null
            source "$CACHE_FILE"
            echo "Using cached brew data"
            return
        fi
    fi

    echo "Refreshing brew cache..."
    BREW_INSTALLED_FORMULAE=$(brew list --formula 2>/dev/null || echo "")
    BREW_INSTALLED_CASKS=$(brew list --cask 2>/dev/null || echo "")
    BREW_OUTDATED_FORMULAE=$(brew outdated --formula 2>/dev/null || echo "")
    BREW_OUTDATED_CASKS=$(brew outdated --cask 2>/dev/null || echo "")
    BREW_TAPS=$(brew tap 2>/dev/null || echo "")

    if [[ -z "$BREW_INSTALLED_FORMULAE" && -z "$BREW_INSTALLED_CASKS" ]]; then
        echo "Warning: Failed to initialize brew cache"
        return 1
    fi

    # Save to disk
    cat >"$CACHE_FILE" <<EOF
BREW_INSTALLED_FORMULAE="$BREW_INSTALLED_FORMULAE"
BREW_INSTALLED_CASKS="$BREW_INSTALLED_CASKS"
BREW_OUTDATED_FORMULAE="$BREW_OUTDATED_FORMULAE"
BREW_OUTDATED_CASKS="$BREW_OUTDATED_CASKS"
BREW_TAPS="$BREW_TAPS"
EOF
    echo "Cache initialized and saved"
}

refresh_brew_cache() {
    rm -f "$CACHE_FILE"
    init_brew_cache
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
    local install_type="${3:-both}" # Default to 'both' if not specified

    if [ -f "$HOME/.extra/.env" ]; then
        source "$HOME/.extra/.env"
    else
        echo "Error: $HOME/.extra/.env not found. Please run install.sh first."
        exit 1
    fi

    if [ "$install_type" = "personal" ] && [ "$IS_WORK_COMPUTER" = "1" ]; then
        echo -e "\033[33m⚠️ Skipping $package ($package_type) installation on work computer\033[0m"
        return 0
    fi
    if [ "$install_type" = "work" ] && [ "$IS_WORK_COMPUTER" = "0" ]; then
        echo -e "\033[33m⚠️ Skipping $package ($package_type) installation on personal computer\033[0m"
        return 0
    fi

    init_brew_cache

    if ! is_package_installed "$package" "$package_type"; then
        echo "Installing $package ($package_type)..."
        if [[ "$package_type" == "cask" ]]; then
            brew install --cask "$package"
        else
            brew install --formula "$package"
        fi
        refresh_brew_cache
    elif is_package_outdated "$package" "$package_type"; then
        echo "Updating $package ($package_type)..."
        if [[ "$package_type" == "cask" ]]; then
            brew upgrade --cask "$package"
        else
            brew upgrade --formula "$package"
        fi
        refresh_brew_cache
    else
        echo -e "\033[32m✓ $package is already installed and up to date\033[0m"
    fi
}

tap_if_needed() {
    local tap=$1

    init_brew_cache

    if ! echo "$BREW_TAPS" | grep -q "^$tap\$"; then
        echo "Tapping $tap..."
        brew tap "$tap"
        refresh_brew_cache
    else
        echo "Tap $tap already exists"
    fi
}

print_header() {
    echo "**************************************************"
    echo "$1"
    echo "**************************************************"
}
