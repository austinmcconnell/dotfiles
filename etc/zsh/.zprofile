#!/bin/zsh
#
# .zprofile - Zsh file loaded on login.
#

# Kiro CLI pre-initialization
[[ -f "$ZDOTDIR/conf.d/kiro-cli.zsh-profile" ]] && source "$ZDOTDIR/conf.d/kiro-cli.zsh-profile" pre

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
    $PYENV_ROOT/bin
    $RBENV_ROOT/bin
    $DOTFILES_DIR/bin(N)
    $HOME/go/bin
    $HOME/.rvm/bin
    $HOME/projects/scripts
    $path
)

export LDFLAGS="-L$(brew --prefix openssl)/lib"  # pyenv python builds
export CPPFLAGS="-I$(brew --prefix openssl)/include"  # pyenv python builds
export CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl)"  # pyenv python builds

export REPO_DIR="$HOME/.repositories"

# Kiro CLI post-initialization
[[ -f "$ZDOTDIR/conf.d/kiro-cli.zsh-profile" ]] && source "$ZDOTDIR/conf.d/kiro-cli.zsh-profile" post
