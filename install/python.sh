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
        brew install ncurses openssl readline xz
        LDFLAGS="-L$(brew --prefix openssl)/lib"
        CPPFLAGS="-I$(brew --prefix openssl)/include"
        CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl)"
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Python"
        echo "**************************************************"
        sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
            libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
            xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git
    else
        echo "**************************************************"
        echo "Skipping Python installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

mkdir -p "$XDG_CONFIG_HOME/pip"
mkdir -p "$XDG_CONFIG_HOME/proselint"
mkdir -p "$XDG_CONFIG_HOME/mypy"
mkdir -p "$XDG_CONFIG_HOME/yapf"
mkdir -p "$XDG_CONFIG_HOME/isort/"
mkdir -p "$XDG_CONFIG_HOME/python"
mkdir -p "$XDG_DATA_HOME/python"
mkdir -p ~/.git-templates

ln -sfv "$DOTFILES_DIR/etc/python/pip.conf" "$XDG_CONFIG_HOME/pip"
ln -sfv "$DOTFILES_DIR/etc/python/flake8" "$XDG_CONFIG_HOME"
ln -sfv "$DOTFILES_DIR/etc/python/yapf" "$XDG_CONFIG_HOME/yapf/style"
ln -sfv "$DOTFILES_DIR/etc/python/pylintrc" "$XDG_CONFIG_HOME"
ln -sfv "$DOTFILES_DIR/etc/python/proselint.json" "$XDG_CONFIG_HOME/proselint/config.json"
ln -sfv "$DOTFILES_DIR/etc/python/mypy" "$XDG_CONFIG_HOME/mypy/config"
ln -sfv "$DOTFILES_DIR/etc/python/.isort.cfg" "$XDG_CONFIG_HOME/isort/config"
ln -sfv "$DOTFILES_DIR/etc/python/pythonrc" "$XDG_CONFIG_HOME/python/pythonrc"

# If there's an existing .python_history file, move it to XDG location
if [[ -f "$HOME/.python_history" ]]; then
    echo "Moving existing .python_history file to XDG_DATA_HOME/python"
    mv "$HOME/.python_history" "$XDG_DATA_HOME/python/python_history"
fi

DEFAULT_PYTHON_VERSION=3.10.6

if is-executable pyenv; then
    pyenv update
fi

PYENV_ROOT="$XDG_DATA_HOME/pyenv"
PYENV_PLUGINS_DIR="$PYENV_ROOT/plugins"

if [ ! -f "$PYENV_ROOT/bin/pyenv" ]; then
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
fi

pyenv_plugins=(pyenv/pyenv-ccache jawshooah/pyenv-default-packages pyenv/pyenv-doctor pyenv/pyenv-implicit pyenv/pyenv-update)

for plugin in "${pyenv_plugins[@]}"; do
    plugin_owner=$(echo "$plugin" | cut -d '/' -f 1)
    plugin_name=$(echo "$plugin" | cut -d '/' -f 2)
    if [ ! -d "$PYENV_PLUGINS_DIR/$plugin_name" ]; then
        git clone "https://github.com/$plugin_owner/$plugin_name.git" "$PYENV_PLUGINS_DIR/$plugin_name"
    fi
done

ln -sfv "$DOTFILES_DIR/etc/python/default-packages" "$PYENV_ROOT" # <-- At end because PYENV_ROOT doesn't exist before pyenv install

"$PYENV_ROOT"/bin/pyenv install --skip-existing $DEFAULT_PYTHON_VERSION
"$PYENV_ROOT"/bin/pyenv global $DEFAULT_PYTHON_VERSION
pip install --upgrade pip setuptools wheel

pre-commit init-templatedir "$HOME"/.config/git/templates
