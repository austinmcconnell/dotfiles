#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

prompt starship

# # Hook for extra/custom stuff (e.g. settings for work laptop)
EXTRA_DIR="$HOME/.extra"
if [ -d "$EXTRA_DIR" ]; then
    for EXTRA_FILE in "$EXTRA_DIR"/.{env,alias,function,path}; do
        [ -f "$EXTRA_FILE" ] && . "$EXTRA_FILE"
    done
fi

# Source fzf key bindings and completions
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
# [[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2>/dev/null # Doesn't seem to do anything


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Bindkeys
bindkey "^e" fzf-cd-widget
# bindkey '\t' end-of-line  # For zsh-autosuggestions. This was messing up directory tab completion

# fnm
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "`fnm env --use-on-cd --version-file-strategy=recursive`"
fi
