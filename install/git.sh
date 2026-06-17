#!/bin/bash

if is-executable git; then
    echo "**************************************************"
    echo "Configuring Git"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Git with brew"
        echo "**************************************************"
        brew install git
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Git with apt"
        echo "**************************************************"
        sudo apt install git
    else
        echo "**************************************************"
        echo "Skipping Git installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

GIT_CONFIG_DIR="$HOME/.config/git"

mkdir -p "$GIT_CONFIG_DIR"
mkdir -p "$GIT_CONFIG_DIR"/hooks

ln -sfv "$DOTFILES_DIR/etc/git/config" "$GIT_CONFIG_DIR"
ln -sfv "$DOTFILES_DIR/etc/git/ignore" "$GIT_CONFIG_DIR"
ln -sfv "$DOTFILES_DIR/etc/git/attributes" "$GIT_CONFIG_DIR"
ln -sfv "$DOTFILES_DIR/etc/git/hooks/commit-msg" "$GIT_CONFIG_DIR"/hooks/commit-msg
ln -sfv "$DOTFILES_DIR/etc/git/hooks/prepare-commit-msg" "$GIT_CONFIG_DIR"/hooks/prepare-commit-msg
ln -sfv "$DOTFILES_DIR/etc/git/hooks/pre-push" "$GIT_CONFIG_DIR"/hooks/pre-push
ln -sfv "$DOTFILES_DIR/etc/git/hooks/post-checkout" "$GIT_CONFIG_DIR"/hooks/post-checkout
ln -sfv "$DOTFILES_DIR/etc/git/config-uniteus" "$GIT_CONFIG_DIR"
ln -sfv "$DOTFILES_DIR/etc/git/commit-template" "$GIT_CONFIG_DIR"/commit-template

if is-macos; then
    ln -sfv "$DOTFILES_DIR/etc/git/config-macos" "$GIT_CONFIG_DIR"
elif is-debian; then
    ln -sfv "$DOTFILES_DIR/etc/git/config-linux" "$GIT_CONFIG_DIR"
fi

# --- Git Maintenance ---
# Create config-maintenance for machine-specific repo registrations (not version-controlled).
# The main config includes this file via [include] path = ./config-maintenance.
MAINTENANCE_CONFIG="$GIT_CONFIG_DIR/config-maintenance"

if [ ! -f "$MAINTENANCE_CONFIG" ]; then
    touch "$MAINTENANCE_CONFIG"
fi

# Ensure LaunchAgents/systemd timers exist for scheduled maintenance.
# Running 'start' in any repo sets up the scheduler; we use dotfiles as the seed repo.
if is-macos && [ ! -f "$HOME/Library/LaunchAgents/org.git-scm.git.hourly.plist" ]; then
    git -C "$DOTFILES_DIR" maintenance start
    # start writes maintenance.repo to global config; move it to config-maintenance
    git config --global --unset-all maintenance.repo 2>/dev/null
fi

# Auto-register discovered repos
for repo in "$DOTFILES_DIR" "$HOME/projects"/*/*; do
    if [ -d "$repo/.git" ]; then
        git -C "$repo" maintenance register --config-file "$MAINTENANCE_CONFIG" 2>/dev/null
    fi
done

# Normalize config-maintenance: consistent indentation, sorted repos, exclude unwanted paths
if [ -f "$MAINTENANCE_CONFIG" ]; then
    printf '[maintenance]\n' >"$MAINTENANCE_CONFIG.tmp"
    sed -n 's/.*repo = //p' "$MAINTENANCE_CONFIG" | sort -u | while read -r repo; do
        case "$repo" in
        "$HOME/.cache/"* | "$HOME/.vim/"* | "$HOME/sources/"* | /tmp/*) continue ;;
        esac
        printf '    repo = %s\n' "$repo"
    done >>"$MAINTENANCE_CONFIG.tmp"
    mv "$MAINTENANCE_CONFIG.tmp" "$MAINTENANCE_CONFIG"
fi
