zmodload zsh/zprof # Call zprof to get startup profiling

export ZSH=~/.oh-my-zsh

ZSH_THEME="spaceship"

zstyle ':omz:lib:theme-and-appearance' gnu-ls yes

plugins=(autoenv terraform)
source $ZSH/oh-my-zsh.sh

DOTFILES_DIR="$HOME/.dotfiles"
export DOTFILES_DIR
# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Finally we can source the dotfiles (order matters)
for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if is-macos; then
    for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}.macos; do
        [ -f "$DOTFILE" ] && . "$DOTFILE"
    done
fi

# Hook for extra/custom stuff
DOTFILES_EXTRA_DIR="$HOME/.extra"

if [ -d "$DOTFILES_EXTRA_DIR" ]; then
    for EXTRAFILE in "$DOTFILES_EXTRA_DIR"/.{env,alias,function,path}; do
        [ -f "$EXTRAFILE" ] && . "$EXTRAFILE"
    done
fi

if is-macos; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Set Nord dircolors ad default color theme
test -r ~/.dir_colors && eval "$(dircolors ~/.dir_colors)"

# source "$HOME/.repositories/kube-ps1/kube-ps1.sh"  # Only needed for custom Austin.zsh theme

# Source chtf
if [[ -f /usr/local/share/chtf/chtf.sh ]]; then
    source "/usr/local/share/chtf/chtf.sh"
fi

# Source rbenv
if is-executable rbenv; then
    eval "$(rbenv init - zsh)"
fi

# Add function to test zsh startup time
timezsh() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do
        /usr/bin/time $shell -i -c exit
    done
}

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# Add cli completions
if is-executable kubectl; then
    source <(kubectl completion zsh)
fi
complete -C '$BREW_PREFIX/bin/aws_completer' aws

# Source fzf key bindings and completions
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2>/dev/null
bindkey "^e" fzf-cd-widget

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use

# place this after nvm initialization!
autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc
load-nvmrc

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
