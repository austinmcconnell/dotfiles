#!/bin/sh

if ! is-executable brew; then
  echo "**************************************************"
  echo "Skipping Python Install: Homebrew not installed"
  echo "**************************************************"
  return
else
  echo "**************************************************"
  echo "Installing Python"
  echo "**************************************************"
fi

ln -sfv "$DOTFILES_DIR/etc/python/flake8" ~/.config
ln -sfv "$DOTFILES_DIR/etc/python/pylintrc" ~/.config

DEFAULT_PYTHON_VERSION=3.7.4

brew install pyenv

PYENV_PLUGIN_DIR="$HOME/.pyenv/plugins"
if [ -d "$PYENV_PLUGIN_DIR/pyenv-implicit/.git" ] ; then
	git --work-tree="$PYENV_PLUGIN_DIR/pyenv-implicit" --git-dir="$PYENV_PLUGIN_DIR/pyenv-implicit/.git" pull origin master;
else
  git clone git://github.com/pyenv/pyenv-implicit.git "$PYENV_PLUGIN_DIR/pyenv-implicit"
fi

pyenv install --skip-existing $DEFAULT_PYTHON_VERSION
pyenv global $DEFAULT_PYTHON_VERSION
