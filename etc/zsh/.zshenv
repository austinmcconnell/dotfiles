#!/bin/zsh

export DOTFILES_IDE="vim"

# Part of https://github.com/mattmc3/zephyr/blob/main/plugins/environment/environment.plugin.zsh
# Config directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# Create user-specific runtime directory in macOS temp location
if [[ "$(uname)" == "Darwin" ]]; then
    export XDG_RUNTIME_DIR="${TMPDIR}user-${UID}"
    if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
        mkdir -p "$XDG_RUNTIME_DIR"
        chmod 0700 "$XDG_RUNTIME_DIR"
    fi
fi

export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
export DOTFILES_DIR="$HOME/.dotfiles"

# Mac OS
export HOMEBREW_API_AUTO_UPDATE_SECS=86400

GPG_TTY="$(tty)"
export GPG_TTY

# Enable colors
export CLICOLOR=1

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"

# Pyenv
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

# PIPENV
export WORKON_HOME=~/.venvs
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_VERBOSITY=-1

# Autoenv
export AUTOENV_ASSUME_YES=1

# Google Cloud SDK
export CLOUDSDK_PYTHON="$PYENV_ROOT/shims/python3.7"

# Set FLAGS
export PATH="$BREW_PREFIX/opt/openssl@1.1/bin:$PATH"
export RUBY_CFLAGS=-DUSE_FFI_CLOSURE_ALLOC
export optflags="-Wno-error=implicit-function-declaration"

# fnm
export FNM_PATH="/Users/$(whoami)/.local/share/fnm"

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

export ABBR_USER_ABBREVIATIONS_FILE="$DOTFILES_DIR/etc/zsh/zsh-abbr/user-abbreviations"

# rbenv
export RBENV_ROOT="$XDG_DATA_HOME/rbenv"

# Ruby
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

# Less
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

# PostgreSQL
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_DATA_HOME/pg/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"

# Terraform
export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraform/terraform.rc"

# wget
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# Python
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
