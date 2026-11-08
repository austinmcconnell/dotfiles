#!/bin/zsh
#
# Shell integration for ai-dotfiles: ai-prompt commands, completions, and env
#

if [[ -r "${AI_DOTFILES_DIR:-$HOME/.ai-dotfiles}/etc/zsh/init.zsh" ]]; then
    source "${AI_DOTFILES_DIR:-$HOME/.ai-dotfiles}/etc/zsh/init.zsh"
fi
