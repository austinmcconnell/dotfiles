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
    /opt/homebrew/opt/ccache/libexec(N)
    /usr/local/{,s}bin(N)
    $DOTFILES_DIR/bin(N)
    $DOTFILES_DIR/etc/zsh/functions(N)
    $path
)

LDFLAGS="-Wl,-rpath,$(brew --prefix openssl)/lib"  #pyenv python builds
CPPFLAGS="-I$(brew --prefix openssl)/include"  #pyenv python builds
CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl)"  #pyenv python builds

export REPO_DIR="$HOME/.repositories"
