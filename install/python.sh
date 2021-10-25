#!/bin/sh

if is-executable pyenv; then
    echo "**************************************************"
    echo "Configuring Python"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Python"
        echo "**************************************************"
        brew install readline xz
        curl https://pyenv.run | bash
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Python"
        echo "**************************************************"
        sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
            libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
            xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
        curl https://pyenv.run | bash
    else
        echo "**************************************************"
        echo "Skipping Python installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

mkdir -p ~/.config/proselint
mkdir -p ~/.config/mypy
mkdir -p ~/.config/isort/

ln -sfv "$DOTFILES_DIR/etc/python/flake8" ~/.config
ln -sfv "$DOTFILES_DIR/etc/python/pylintrc" ~/.config
ln -sfv "$DOTFILES_DIR/etc/python/proselint" ~/.config/proselint/config
ln -sfv "$DOTFILES_DIR/etc/python/mypy" ~/.config/mypy/config
ln -sfv "$DOTFILES_DIR/etc/python/.isort.cfg" ~/.config/isort/.isort.cfg
ln -sfv "$DOTFILES_DIR/scripts/reinitialize-git-repositories.py" ~/projects
ln -sfv "$DOTFILES_DIR/scripts/sort-git-repos-by-owner.py" ~/projects

DEFAULT_PYTHON_VERSION=3.7.4

mkdir -p ~/.pyenv
ln -sfv "$DOTFILES_DIR/etc/python/default-packages" ~/.pyenv

REPO_DIR="$HOME/.pyenv/plugins/pyenv-implicit"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone git://github.com/pyenv/pyenv-implicit.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.pyenv/plugins/pyenv-default-packages"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone git://github.com/jawshooah/pyenv-default-packages.git "$REPO_DIR"
fi

pyenv install --skip-existing $DEFAULT_PYTHON_VERSION
pyenv global $DEFAULT_PYTHON_VERSION
