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
    /opt/homebrew/opt/{coreutils,grep,findutils}/libexec/gnubin(N)
    /opt/homebrew/opt/ccache/libexec(N)
    /usr/local/{,s}bin(N)
    $DOTFILES_DIR/bin(N)
    $DOTFILES_DIR/etc/zsh/functions(N)
    $HOME/go/bin
    $path
)

export LDFLAGS="-L$(brew --prefix openssl)/lib"  # pyenv python builds
export CPPFLAGS="-I$(brew --prefix openssl)/include"  # pyenv python builds
export CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl)"  # pyenv python builds

export REPO_DIR="$HOME/.repositories"
