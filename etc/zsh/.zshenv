#!/bin/zsh

# Config directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_RUNTIME_DIR="$HOME/.xdg"
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
export DOTFILES_DIR="$HOME/.dotfiles"

# Mac OS
export HOMEBREW_AUTO_UPDATE_SECS=86400

GPG_TTY="$(tty)"
export GPG_TTY

# Enable colors
export CLICOLOR=1

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# PIPENV
export WORKON_HOME=~/.venvs
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_VERBOSITY=-1

# Autoenv
export AUTOENV_ASSUME_YES=1
export AUTOENV_ENABLE_LEAVE=1

# Spaceship prompt
export SPACESHIP_DOCKER_SHOW=false
export SPACESHIP_GCLOUD_SHOW=false
export SPACESHIP_NODE_SHOW=false
export SPACESHIP_KUBECTL_SHOW=false
export SPACESHIP_KUBECTL_VERSION_SHOW=false
export SPACESHIP_VENV_GENERIC_NAMES=()
export SPACESHIP_BATTERY_THRESHOLD=20
export SPACESHIP_JOBS_AMOUNT_THRESHOLD=0

# Google Cloud SDK
export CLOUDSDK_PYTHON=~/.pyenv/shims/python3.7

# Set FLAGS
export PATH="$BREW_PREFIX/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L$BREW_PREFIX/opt/openssl@1.1/lib"
export CPPFLAGS="-I$BREW_PREFIX/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="$BREW_PREFIX/opt/openssl@1.1/lib/pkgconfig"
export RUBY_CFLAGS=-DUSE_FFI_CLOSURE_ALLOC
export optflags="-Wno-error=implicit-function-declaration"

#NVM
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY=1
lts_name=$(cat $NVM_DIR/alias/lts/'*')
export NVM_LTS_VERSION=$(cat $NVM_DIR/alias/$lts_name)

# kube-ps1
get_cluster_short() {
    echo "$1" | cut -d _ -f 2
}

export KUBE_PS1_SYMBOL_ENABLE=false
export KUBE_PS1_NS_COLOR=yellow
export KUBE_PS1_CTX_COLOR=yellow
export KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short

# fzf settings
export FZF_DEFAULT_COMMAND="fd --hidden --follow --color=always"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type directory"
export FZF_DEFAULT_OPTS="--ansi --color=dark --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B"
export FZF_CTRL_T_OPTS="--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --color header:italic --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Use .zprofile to set environment vars for non-login, non-interactive shells.
if [[ ("$SHLVL" -eq 1 && ! -o LOGIN) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprofile"
fi
