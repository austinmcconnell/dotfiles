#!/bin/zsh
#
# .zprofile - Zsh file loaded on login.
#

#
# Editors
#

export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"

#
# Paths
#

# Set the list of directories that zsh searches for commands.
path=(
    $HOME/{,s}bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    /opt/homebrew/opt/ruby/bin(N)
    /opt/homebrew/opt/{coreutils,grep}/libexec/gnubin(N)
    /usr/local/{,s}bin(N)
    $DOTFILES_DIR/bin(N)
    $DOTFILES_DIR/etc/zsh/functions(N)
    $path
)

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
