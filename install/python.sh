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
        brew install libb2 ncurses openssl readline xz
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
mkdir -p "$XDG_CONFIG_HOME/ruff"
mkdir -p "$XDG_DATA_HOME/python"
mkdir -p ~/.git-templates

ln -sfv "$DOTFILES_DIR/etc/python/pip.conf" "$XDG_CONFIG_HOME/pip"
ln -sfv "$DOTFILES_DIR/etc/python/autopep8" "$XDG_CONFIG_HOME/pycodestyle"
ln -sfv "$DOTFILES_DIR/etc/python/flake8" "$XDG_CONFIG_HOME"
ln -sfv "$DOTFILES_DIR/etc/python/yapf" "$XDG_CONFIG_HOME/yapf/style"
ln -sfv "$DOTFILES_DIR/etc/python/pylintrc" "$XDG_CONFIG_HOME"
ln -sfv "$DOTFILES_DIR/etc/python/ruff.toml" "$XDG_CONFIG_HOME/ruff/ruff.toml"
ln -sfv "$DOTFILES_DIR/etc/python/proselint.json" "$XDG_CONFIG_HOME/proselint/config.json"
ln -sfv "$DOTFILES_DIR/etc/python/mdformat.toml" "$HOME/.mdformat.toml"
ln -sfv "$DOTFILES_DIR/etc/python/mypy" "$XDG_CONFIG_HOME/mypy/config"
ln -sfv "$DOTFILES_DIR/etc/python/.isort.cfg" "$XDG_CONFIG_HOME/isort/config"
ln -sfv "$DOTFILES_DIR/etc/python/pythonrc" "$XDG_CONFIG_HOME/python/pythonrc"

# If there's an existing .python_history file, move it to XDG location
if [[ -f "$HOME/.python_history" ]]; then
    echo "Moving existing .python_history file to XDG_DATA_HOME/python"
    mv "$HOME/.python_history" "$XDG_DATA_HOME/python/python_history"
fi

DEFAULT_PYTHON_VERSION=3.13.12

if is-executable pyenv; then
    pyenv update
fi

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
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

"$PYENV_ROOT"/bin/pyenv install --skip-existing $DEFAULT_PYTHON_VERSION
"$PYENV_ROOT"/bin/pyenv global $DEFAULT_PYTHON_VERSION

# Add pyenv shims to PATH for the rest of this script
eval "$("$PYENV_ROOT"/bin/pyenv init --path)"

pip install --upgrade pip setuptools wheel

# Per-directory pins resolve to these uv-managed interpreters (see conf.d). -U moves an
# existing install to the latest patch, since a minor spec alone never upgrades it.
# --system-certs because the bundled CA roots reject the TLS issuer on networks that
# intercept HTTPS.
UV_PYTHON_VERSIONS=(3.11 3.12 3.13 3.14 3.15)
if ! is-executable uv; then
    echo "Skipping uv-managed Python interpreters: uv is not installed" >&2
else
    uv python install --system-certs -U "${UV_PYTHON_VERSIONS[@]}"
fi

# Global tools live in isolated uv tool environments, not in each pyenv version
if ! is-executable uv; then
    echo "Skipping global Python tools: uv is not installed" >&2
else
    while IFS= read -r tool_line; do
        [[ -z "$tool_line" || "$tool_line" == \#* ]] && continue
        read -r -a tool_args <<<"$tool_line"
        uv tool install "${tool_args[@]}"
    done <"$DOTFILES_DIR/etc/python/uv-tools"
fi
