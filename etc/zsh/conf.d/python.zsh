#!/bin/zsh
#
# python.zsh - Python configurations and aliases
#

##############################
# Environment Variables
##############################

# Add pyenv to PATH early to ensure it's available
if [[ -d "$PYENV_ROOT/bin" ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

# Initialize pyenv from a cached static file instead of spawning a subprocess
# Cache auto-invalidates when the pyenv binary changes (e.g., after brew upgrade)
if command -v pyenv >/dev/null; then
  local cache="$XDG_CACHE_HOME/zsh/pyenv-init.zsh"
  if [[ ! -s "$cache" || "${commands[pyenv]}" -nt "$cache" ]]; then
    mkdir -p "${cache:h}"
    # Strip the bash PATH dedup block — we handle PATH ourselves with zsh arrays
    pyenv init - --no-rehash zsh | sed '/^PATH="\$(bash/,/^export PATH=/d' >| "$cache"
  fi
  path=("$PYENV_ROOT/shims" ${path:#$PYENV_ROOT/shims})
  source "$cache"
fi

# Default python and python3 from install/python.sh; placed after the pyenv shims so it wins
path=("$XDG_DATA_HOME/python/default/bin" ${path:#$XDG_DATA_HOME/python/default/bin})

# Resolve bare python/python3 to the directory's .python-version via uv. Runs after the pyenv
# block above so its shim dir lands ahead of pyenv shims, and only prepends in pinned directories.
_python_implicit_shims="$XDG_CACHE_HOME/zsh/python-implicit"

function _python_implicit_chpwd() {
  path=(${path:#$_python_implicit_shims})

  local dir="$PWD"
  while [[ "$dir" != "/" && ! -f "$dir/.python-version" ]]; do
    dir="${dir:h}"
  done
  [[ -f "$dir/.python-version" ]] || return 0

  local interpreter
  if ! interpreter=$(uv python find 2>/dev/null); then
    print -u2 "python-implicit: pinned version not installed (run: uv python install $(<"$dir/.python-version"))"
    return 0
  fi

  mkdir -p "$_python_implicit_shims"
  ln -sfn "$interpreter" "$_python_implicit_shims/python"
  ln -sfn "$interpreter" "$_python_implicit_shims/python3"
  path=("$_python_implicit_shims" $path)
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _python_implicit_chpwd
_python_implicit_chpwd

# PIPENV
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_VERBOSITY=-1

# Autoenv
export AUTOENV_ASSUME_YES=1

# Google Cloud SDK
export CLOUDSDK_PYTHON="$PYENV_ROOT/shims/python3.7"

# Python startup file
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

##############################
# Python Aliases
##############################
alias pipcache='pip download --dest ${HOME}/.pip/packages'
alias pipinstall='pip install --no-index --find-links=file://${HOME}/.pip/packages/'
alias cleanupvenv="find . -name '.venv' -exec rm -rf '{}' +"
