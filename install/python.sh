#!/bin/bash
# shellcheck disable=SC2034

if is-executable uv; then
    echo "**************************************************"
    echo "Configuring Python"
    echo "**************************************************"
else
    echo "**************************************************"
    echo "Installing Python"
    echo "**************************************************"
    brew install uv
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

mkdir -p "$XDG_CONFIG_HOME/pip"
ln -sfv "$DOTFILES_DIR/etc/python/pip.conf" "$XDG_CONFIG_HOME/pip/pip.conf"
ln -sfv "$DOTFILES_DIR/etc/python/autopep8" "$XDG_CONFIG_HOME/pycodestyle"
ln -sfv "$DOTFILES_DIR/etc/python/flake8" "$XDG_CONFIG_HOME/flake8"
ln -sfv "$DOTFILES_DIR/etc/python/yapf" "$XDG_CONFIG_HOME/yapf/style"
ln -sfv "$DOTFILES_DIR/etc/python/pylintrc" "$XDG_CONFIG_HOME/pylintrc"
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

# Per-directory pins resolve to these uv-managed interpreters (see conf.d). -U moves an
# existing install to the latest patch, since a minor spec alone never upgrades it.
# --system-certs because the bundled CA roots reject the TLS issuer on networks that
# intercept HTTPS.
UV_PYTHON_VERSIONS=(3.11 3.12 3.13 3.14 3.15)
if ! is-executable uv; then
    echo "Skipping uv-managed Python interpreters: uv is not installed" >&2
else
    failed_interpreters=()
    for version in "${UV_PYTHON_VERSIONS[@]}"; do
        uv python install --system-certs -U "$version" || failed_interpreters+=("$version")
    done
    if [[ ${#failed_interpreters[@]} -gt 0 ]]; then
        echo "uv python install failed: ${failed_interpreters[*]}" >&2
    fi
fi

# Bare python and python3 use the second-newest uv minor: a new release gets a few months of
# ecosystem catch-up before it becomes the default. conf.d/python.zsh puts this dir on PATH.
PYTHON_DEFAULT_BIN="$XDG_DATA_HOME/python/default/bin"
if ! is-executable uv || ! is-executable jq; then
    echo "Skipping default python: uv and jq are required" >&2
else
    # shellcheck disable=SC2016 # $ARGS is a jq variable, not a shell expansion
    second_newest_minor='
        [.[].version_parts | "\(.major).\(.minor)"] | unique
        | map(select(. as $minor | $ARGS.positional | index($minor)))
        | sort_by(split(".") | map(tonumber)) | .[-2] // empty
    '
    default_minor=$(uv python list --only-installed --managed-python --output-format json |
        jq -r --args "$second_newest_minor" "${UV_PYTHON_VERSIONS[@]}")
    if [[ -z "$default_minor" ]]; then
        echo "Skipping default python: fewer than two uv-managed minors installed" >&2
    else
        default_interpreter=$(uv python find --managed-python "$default_minor")
        mkdir -p "$PYTHON_DEFAULT_BIN"
        ln -sfn "$default_interpreter" "$PYTHON_DEFAULT_BIN/python"
        ln -sfn "$default_interpreter" "$PYTHON_DEFAULT_BIN/python3"
    fi
fi

# Global tools live in isolated uv tool environments, pinned to the default minor so a new
# release cannot break their installs before it becomes the default.
if ! is-executable uv || [[ -z "${default_minor:-}" ]]; then
    echo "Skipping global Python tools: uv and a default minor are required" >&2
else
    failed_tools=()
    while IFS= read -r line; do
        [[ -n "$line" && "$line" != \#* ]] || continue
        read -ra tool_args <<<"$line"
        uv tool install --python "$default_minor" "${tool_args[@]}" ||
            failed_tools+=("${tool_args[0]}")
    done <"$DOTFILES_DIR/etc/python/uv-tools"
    if [[ ${#failed_tools[@]} -gt 0 ]]; then
        echo "uv tools failed to install: ${failed_tools[*]}" >&2
    fi
fi
