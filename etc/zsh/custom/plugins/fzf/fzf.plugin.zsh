#!/bin/zsh
#
# fzf.plugin.zsh - Configure fzf key bindings and completions
#

# Source fzf key bindings and completions
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

# Uncomment if needed
# if [[ $- == *i* && -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
#   source /opt/homebrew/opt/fzf/shell/completion.zsh
# fi

# Custom key bindings for fzf
bindkey "^e" fzf-cd-widget
