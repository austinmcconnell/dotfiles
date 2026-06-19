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
            _check_pip_audit
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
    elif (( $+commands[uv] )); then
        if [[ -f uv.lock ]]; then
            uv sync
            source .venv/bin/activate
        else
            uv venv
            source .venv/bin/activate
            if [[ -f requirements.txt ]]; then
                uv pip install -r requirements.txt
            elif [[ -f pyproject.toml ]]; then
                uv pip install -e .
            fi
        fi
    else
        python -m venv .venv
        source .venv/bin/activate
        if [[ -f requirements.txt ]]; then
            pip install -r requirements.txt
        elif [[ -f pyproject.toml ]]; then
            pip install -e .
        fi
    fi

    # Remind user to audit
    if (( $+commands[uv] )) && [[ -f uv.lock ]] || (( $+commands[pip-audit] )); then
        echo "💡 Run \033[95mauditvenv\033[0m to check for vulnerabilities."
    fi
}

function _check_pip_audit() {
    [[ -d .venv ]] || return
    (( $+commands[pip-audit] )) || { (( $+commands[uv] )) && [[ -f uv.lock ]] } || return
    local audit_file=".venv/.pip-audit"
    if [[ ! -f "$audit_file" ]]; then
        echo "🔍 pip-audit has never been run. Run \033[95mauditvenv\033[0m to check for vulnerabilities."
    elif [[ $(find "$audit_file" -mtime +30 2>/dev/null) ]]; then
        echo "🔍 pip-audit last run >30 days ago. Run \033[95mauditvenv\033[0m to re-check."
    fi
}

function auditvenv() {
    local rc
    if (( $+commands[uv] )) && [[ -f uv.lock ]]; then
        uv audit; rc=$?
    elif [[ -f Pipfile ]] && (( $+commands[pipenv] )) && (( $+commands[pip-audit] )); then
        pip-audit -r <(pipenv requirements) --no-deps --disable-pip; rc=$?
    elif (( $+commands[pip-audit] )); then
        pip-audit -r <(uv pip freeze --python .venv/bin/python 2>/dev/null || .venv/bin/pip freeze) --no-deps --disable-pip; rc=$?
    else
        echo "No audit tool found. Install uv or pip-audit." >&2
        return 2
    fi
    if (( rc <= 1 )); then
        touch .venv/.pip-audit
    fi
    return $rc
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _venv_chpwd

# Run on shell startup for the initial directory
_venv_chpwd
