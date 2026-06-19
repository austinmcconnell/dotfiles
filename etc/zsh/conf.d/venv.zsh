#!/bin/zsh
#
# venv.zsh - Auto-activate/deactivate Python virtual environments on cd
#

function _find_venv() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.venv" && -f "$dir/.venv/bin/activate" ]]; then
            echo "$dir/.venv"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

function _has_python_project() {
    [[ -f requirements.txt || -f pyproject.toml || -f setup.py || -f Pipfile ]]
}

function _venv_chpwd() {
    local venv_path
    venv_path=$(_find_venv)

    if [[ -n "$venv_path" ]]; then
        local normalized_venv="${venv_path:A}"
        local normalized_current="${VIRTUAL_ENV:+${VIRTUAL_ENV:A}}"

        if [[ "$normalized_current" != "$normalized_venv" ]]; then
            if [[ -n "${VIRTUAL_ENV:-}" ]] && type deactivate >/dev/null 2>&1; then
                deactivate
            fi
            source "$venv_path/bin/activate"
        fi
    else
        if [[ -n "${VIRTUAL_ENV:-}" ]] && type deactivate >/dev/null 2>&1; then
            deactivate
        fi

        if _has_python_project && [[ ! -d .venv ]]; then
            echo "🐍 Python project detected without a .venv. Run \033[95mmkvenv\033[0m to create one."
        fi
    fi
}

function mkvenv() {
    if [[ -f Pipfile ]]; then
        pipenv install
    else
        python -m venv .venv
        source .venv/bin/activate
        if [[ -f requirements.txt ]]; then
            pip install -r requirements.txt
        fi
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _venv_chpwd

# Run on shell startup for the initial directory
_venv_chpwd
