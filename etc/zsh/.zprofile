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
    /opt/homebrew/opt/{coreutils,findutils,gawk,gnu-sed,gnu-tar,gnu-time,grep}/libexec/gnubin(N)
    /opt/homebrew/opt/ccache/libexec(N)
    /usr/local/{,s}bin(N)
    $RBENV_ROOT/shims
    $RBENV_ROOT/bin
    $DOTFILES_DIR/bin(N)
    $DOTFILES_DIR/scripts(N)
    $AI_DOTFILES_DIR/bin(N)
    $HOME/go/bin
    $HOME/.rvm/bin
    $path
)
