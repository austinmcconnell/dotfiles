#!/bin/zsh
#
# .zshenv - Core environment variables that should be available to all shells
#

export DOTFILES_IDE="vim"

# XDG Base Directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# Zsh directories
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
export DOTFILES_DIR="$HOME/.dotfiles"

# macOS runtime directory
export XDG_RUNTIME_DIR="${TMPDIR}user-${UID}"

# Version managers (needed early for PATH setup)
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export RBENV_ROOT="$XDG_DATA_HOME/rbenv"
export FNM_PATH="$XDG_DATA_HOME/fnm"

# GPG
GPG_TTY="$(tty)"
export GPG_TTY

# Enable colors
export CLICOLOR=1

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"

# zsh-abbr
export ABBR_USER_ABBREVIATIONS_FILE="$DOTFILES_DIR/etc/zsh/zsh-abbr/user-abbreviations"

# Create XDG_RUNTIME_DIR if it doesn't exist
if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 0700 "$XDG_RUNTIME_DIR"
fi

# Use .zprofile to set environment vars for non-login, non-interactive shells.
if [[ ("$SHLVL" -eq 1 && ! -o LOGIN) && -s "$ZDOTDIR/.zprofile" ]]; then
    source "$ZDOTDIR/.zprofile"
fi
