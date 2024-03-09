#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

setopt extended_glob

ZFUNCDIR=${ZFUNCDIR:-$ZDOTDIR/functions}
fpath=($ZFUNCDIR $fpath)
autoload -Uz $fpath[1]/*(.:t)

[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

autoload -Uz promptinit && promptinit
prompt spaceship

# # Hook for extra/custom stuff (e.g. settings for work laptop)
DOTFILES_EXTRA_DIR="$HOME/.extra"
if [ -d "$DOTFILES_EXTRA_DIR" ]; then
    for EXTRAFILE in "$DOTFILES_EXTRA_DIR"/.{env,alias,function,path}; do
        [ -f "$EXTRAFILE" ] && . "$EXTRAFILE"
    done
fi

# Add function to test zsh startup time
timezsh() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do
        /usr/bin/time $shell -i -c exit
    done
}

# Source fzf key bindings and completions
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2>/dev/null
bindkey "^e" fzf-cd-widget


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
