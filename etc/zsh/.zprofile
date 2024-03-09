#!/bin/zsh
#
# .zprofile - Zsh file loaded on login.
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER="${BROWSER:-open}"
fi

#
# Editors
#

export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"
export PAGER="${PAGER:-less}"
export DOTFILES_IDE="vim"

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

# Set the list of directories that zsh searches for commands.
path=(
    $HOME/{,s}bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    /opt/homebrew/opt/ruby/bin(N)
    /opt/homebrew/opt/{coreutils,grep}/libexec/gnubin(N)
    $NVM_DIR/versions/node/$lts_version/bin(N)
    /usr/local/{,s}bin(N)
    $DOTFILES_DIR/bin(N)
    $DOTFILES_DIR/etc/zsh/functions(N)
    $path
)

# Set PATH, MANPATH, etc., for Homebrew.
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
