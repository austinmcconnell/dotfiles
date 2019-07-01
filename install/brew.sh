#!/bin/sh

if ! is-executable brew; then
  echo "**************************************************"
  echo "Skipping Brew Installs: Homebrew not installed"
  echo "**************************************************"
  return
else
  echo "**************************************************"
  echo "Installing Homebrew packages"
  echo "**************************************************"
fi

brew tap Goles/battery
brew tap heroku/brew
brew tap Yleisradio/terraforms

# Install packages
brew install autoenv
brew install bash
brew install bats
brew install battery
brew install chtf
brew install circleci
brew install coreutils
brew install ctags
brew install diff-so-fancy
brew install docker
brew install dockutil
brew install git
brew install git-crypt
brew install git-extras
brew install grep
brew install heroku
brew install httpie
brew install hub
brew install jq
brew install kubectx
brew install kubernetes-helm
brew install mackup
brew install nano
brew install node
brew install postgresql
brew install psgrep
brew install pyenv
brew install redis
brew install ruby
brew install shellcheck
brew install ssh-copy-id
brew install stern
brew install terraform
brew install tree
brew install unar
brew install wget
brew install wifi-password

PYENV_PLUGIN_DIR="$HOME/.pyenv/plugins"
if [ -d "$PYENV_PLUGIN_DIR/pyenv-implicit/.git" ] ; then
	git --work-tree="$PYENV_PLUGIN_DIR/pyenv-implicit" --git-dir="$PYENV_PLUGIN_DIR/pyenv-implicit/.git" pull origin master;
else
  git clone git://github.com/pyenv/pyenv-implicit.git "$PYENV_PLUGIN_DIR/pyenv-implicit"
fi
