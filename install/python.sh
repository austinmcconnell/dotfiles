#!/bin/bash
# shellcheck disable=SC2034

if is-executable pyenv; then
    echo "**************************************************"
    echo "Configuring Python"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Python"
        echo "**************************************************"
        brew install ncurses openssl readline xz zlib
        LDFLAGS="-Wl,-rpath,$(brew --prefix openssl)/lib"
        CPPFLAGS="-I$(brew --prefix openssl)/include"
        CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl)"
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
ln -sfv "$DOTFILES_DIR/etc/python/.isort.cfg" ~/.config/isort/config
ln -sfv "$DOTFILES_DIR/scripts/reinitialize_git_repositories.py" ~/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/sort_git_repos_by_owner.py" ~/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/sort_docker_compose.py" ~/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/free-space-alert.scpt" ~/projects/scripts

DEFAULT_PYTHON_VERSION=3.10.6

if is-executable pyenv; then
    pyenv update
fi

PYENV_DIR="$HOME/.pyenv"
PYENV_PLUGINS_DIR="$PYENV_DIR/plugins"

REPO_NAME=pyenv
if [ ! -d "$PYENV_DIR" ]; then
    git clone https://github.com/pyenv/pyenv.git "$PYENV_DIR"
fi

REPO_NAME=pyenv-implicit
if [ ! -d "$PYENV_PLUGINS_DIR/$REPO_NAME" ]; then
    git clone https://github.com/pyenv/pyenv-implicit.git "$PYENV_PLUGINS_DIR/$REPO_NAME"
fi

REPO_NAME="pyenv-update"
if [ ! -d "$PYENV_PLUGINS_DIR/$REPO_NAME" ]; then
    git clone https://github.com/pyenv/pyenv-update.git "$PYENV_PLUGINS_DIR/$REPO_NAME"
fi

REPO_NAME=pyenv-ccache
if [ ! -d "$PYENV_PLUGINS_DIR/$REPO_NAME" ]; then
    git clone https://github.com/pyenv/pyenv-ccache.git "$PYENV_PLUGINS_DIR/$REPO_NAME"
fi

REPO_NAME=pyenv-doctor
if [ ! -d "$PYENV_PLUGINS_DIR/$REPO_NAME" ]; then
    git clone https://github.com/pyenv/pyenv-doctor.git "$PYENV_PLUGINS_DIR/$REPO_NAME"
fi

REPO_NAME=pyenv-default-packages
if [ ! -d "$PYENV_PLUGINS_DIR/$REPO_NAME" ]; then
    git clone https://github.com/jawshooah/pyenv-default-packages.git "$PYENV_PLUGINS_DIR/$REPO_NAME"
fi

ln -sfv "$DOTFILES_DIR/etc/python/default-packages" "$PYENV_DIR" # <-- At end because PYENV_DIR doesn't exist before pyenv install
"$PYENV_DIR"/bin/pyenv install --skip-existing $DEFAULT_PYTHON_VERSION
"$PYENV_DIR"/bin/pyenv global $DEFAULT_PYTHON_VERSION

pre-commit init-templatedir "$HOME"/.config/git/templates
