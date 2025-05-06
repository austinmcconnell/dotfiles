#!/bin/zsh
#
# dircolors.zsh - Configure dircolors for terminal
#

# Function to set dircolors theme
set_dircolors_theme() {
    local theme="$1"

    if [[ -f "$HOME/.dircolors/$theme" ]]; then
        eval "$(dircolors "$HOME/.dircolors/$theme")"
        echo "Dircolors theme set to: $theme"
    else
        echo "Theme '$theme' not found. Using default."
        # Fall back to .dir_colors if theme not found
        [[ -f "$HOME/.dir_colors" ]] && eval "$(dircolors "$HOME/.dir_colors")"
    fi
}

# Set dircolors from .dir_colors (default)
[[ -f "$HOME/.dir_colors" ]] && eval "$(dircolors "$HOME/.dir_colors")"

# Define aliases to easily switch between themes
alias dircolors-nord="set_dircolors_theme nord"
alias dircolors-bliss="set_dircolors_theme bliss"
alias dircolors-list="ls -la $HOME/.dircolors"
