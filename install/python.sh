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
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Python"
        echo "**************************************************"
        sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
            libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
            xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
    else
        echo "**************************************************"
        echo "Skipping Python installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

mkdir -p ~/.config/pip
mkdir -p ~/.config/proselint
mkdir -p ~/.config/mypy
mkdir -p ~/.config/yapf
mkdir -p ~/.config/isort/
mkdir -p ~/projects/scripts
mkdir -p ~/.git-templates

ln -sfv "$DOTFILES_DIR/etc/python/pip.conf" ~/.config/pip
ln -sfv "$DOTFILES_DIR/etc/python/flake8" ~/.config
ln -sfv "$DOTFILES_DIR/etc/python/yapf" ~/.config/yapf/style
ln -sfv "$DOTFILES_DIR/etc/python/pylintrc" ~/.config
ln -sfv "$DOTFILES_DIR/etc/python/proselint.json" ~/.config/proselint/config.json
ln -sfv "$DOTFILES_DIR/etc/python/mypy" ~/.config/mypy/config
ln -sfv "$DOTFILES_DIR/etc/python/.isort.cfg" ~/.config/isort/.isort.cfg
ln -sfv "$DOTFILES_DIR/scripts/reinitialize-git-repositories.py" ~/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/sort-git-repos-by-owner.py" ~/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/sort-docker-compose.py" ~/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/free-space-alert.scpt" ~/projects/scripts

DEFAULT_PYTHON_VERSION=3.10.6

REPO_DIR="$HOME/.repositories/pyenv"
PYENV_DIR="$HOME/.pyenv"

if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/pyenv/pyenv.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$PYENV_DIR"
    ln -sfv "$DOTFILES_DIR/etc/python/default-packages" "$PYENV_DIR"
fi

REPO_DIR="$HOME/.repositories/pyenv-implicit"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/pyenv/pyenv-implicit.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$PYENV_DIR/plugins/pyenv-implicit"
fi

REPO_DIR="$HOME/.repositories/pyenv-default-packages"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/jawshooah/pyenv-default-packages.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$PYENV_DIR/plugins/pyenv-default-packages"
fi

"$PYENV_DIR"/bin/pyenv install --skip-existing $DEFAULT_PYTHON_VERSION
"$PYENV_DIR"/bin/pyenv global $DEFAULT_PYTHON_VERSION

pre-commit init-templatedir "$HOME"/.config/git/templates
