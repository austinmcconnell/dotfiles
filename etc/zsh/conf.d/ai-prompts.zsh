#!/bin/zsh
#
# AI prompt management configuration with subcommands and tab completion
#

# Source AI prompt management functions (works with any AI service)
if [[ -f "$AI_DOTFILES_DIR/scripts/ai-prompt.sh" ]]; then
    source "$AI_DOTFILES_DIR/scripts/ai-prompt.sh"
fi
