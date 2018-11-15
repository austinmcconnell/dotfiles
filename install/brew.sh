#!/bin/sh

if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
  return
fi

if ! is-executable brew; then
  echo "Homebrew already installed. Skipping install..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap Goles/battery
brew tap heroku/brew
brew update
brew upgrade

# Install packages

apps=(
  autoenv
  bats
  battery
  coreutils
  diff-so-fancy
  docker
  dockutil
  git
  git-extras
  grep --with-default-names
  heroku
  httpie
  hub
  mackup
  nano
  postgresql --with-python3
  psgrep
  pyenv
  shellcheck
  ssh-copy-id
  tree
  unar
  wget
  wifi-password
)

brew install "${apps[@]}"

PYENV_PLUGIN_DIR="$HOME/.pyenv/plugins"
if [ -d "$PYENV_PLUGIN_DIR/pyenv-implicit/.git" ] ; then
	git --work-tree="$PYENV_PLUGIN_DIR/pyenv-implicit" --git-dir="$PYENV_PLUGIN_DIR/pyenv-implicit/.git" pull origin master;
else
  git clone git://github.com/pyenv/pyenv-implicit.git "$PYENV_PLUGIN_DIR/pyenv-implicit"
fi

export DOTFILES_BREW_PREFIX_COREUTILS=`brew --prefix coreutils`

ln -sfv "$DOTFILES_DIR/etc/mackup/.mackup.cfg" ~
