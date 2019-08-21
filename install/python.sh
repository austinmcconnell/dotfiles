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

mkdir -p ~/.config/proselint
mkdir -p ~/.config/mypy

ln -sfv "$DOTFILES_DIR/etc/python/flake8" ~/.config
ln -sfv "$DOTFILES_DIR/etc/python/pylintrc" ~/.config
ln -sfv "$DOTFILES_DIR/etc/python/proselint" ~/.config/proselint/config
ln -sfv "$DOTFILES_DIR/etc/python/mypy" ~/.config/mypy/config

DEFAULT_PYTHON_VERSION=3.7.4

brew install pyenv

ln -sfv "$DOTFILES_DIR/etc/python/default-packages" ~/.pyenv

PYENV_PLUGIN_DIR="$HOME/.pyenv/plugins"

if [ -d "$PYENV_PLUGIN_DIR/pyenv-implicit/.git" ] ; then
	git --work-tree="$PYENV_PLUGIN_DIR/pyenv-implicit" --git-dir="$PYENV_PLUGIN_DIR/pyenv-implicit/.git" pull origin master;
else
  git clone git://github.com/pyenv/pyenv-implicit.git "$PYENV_PLUGIN_DIR/pyenv-implicit"
fi

if [ -d "$PYENV_PLUGIN_DIR/pyenv-default-packages/.git" ] ; then
	git --work-tree="$PYENV_PLUGIN_DIR/pyenv-default-packages" --git-dir="$PYENV_PLUGIN_DIR/pyenv-default-packages/.git" pull origin master;
else
  git clone git://github.com/jawshooah/pyenv-default-packages.git "$PYENV_PLUGIN_DIR/pyenv-default-packages"
fi

pyenv install --skip-existing $DEFAULT_PYTHON_VERSION
pyenv global $DEFAULT_PYTHON_VERSION
