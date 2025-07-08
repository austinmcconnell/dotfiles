#!/bin/zsh
#
# AI prompt management configuration
#

# Source AI prompt management functions (works with any AI service)
if [[ -f "$DOTFILES_DIR/scripts/ai-prompts.sh" ]]; then
    source "$DOTFILES_DIR/scripts/ai-prompts.sh"
fi
