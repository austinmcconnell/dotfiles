#!/bin/zsh
#
# python.zsh - Python configurations and aliases
#

##############################
# Environment Variables
##############################

# Default python and python3 from install/python.sh
path=("$XDG_DATA_HOME/python/default/bin" ${path:#$XDG_DATA_HOME/python/default/bin})

# Resolve bare python/python3 to the directory's .python-version via uv. Each pin gets its own link
# dir, so shells in different pinned directories never overwrite each other's links.
_python_implicit_root="$XDG_CACHE_HOME/zsh/python-implicit"

function _python_implicit_chpwd() {
  path=(${path:#$_python_implicit_root/*})
  (( $+commands[uv] )) || return 0

  local dir="$PWD"
  while [[ "$dir" != "/" && ! -f "$dir/.python-version" ]]; do
    dir="${dir:h}"
  done
  [[ -f "$dir/.python-version" ]] || return 0

  local pin shims interpreter
  pin=$(<"$dir/.python-version")
  shims="$_python_implicit_root/$pin"
  if ! interpreter=$(uv python find 2>/dev/null); then
    print -u2 "python-implicit: pinned version not installed (run: uv python install $pin)"
    return 0
  fi

  mkdir -p "$shims"
  ln -sfn "$interpreter" "$shims/python"
  ln -sfn "$interpreter" "$shims/python3"
  path=("$shims" $path)
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _python_implicit_chpwd
_python_implicit_chpwd

# PIPENV
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_VERBOSITY=-1

# Autoenv
export AUTOENV_ASSUME_YES=1

# Python startup file
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

##############################
# Python Aliases
##############################
alias pipcache='pip download --dest ${HOME}/.pip/packages'
alias pipinstall='pip install --no-index --find-links=file://${HOME}/.pip/packages/'
alias cleanupvenv="find . -name '.venv' -exec rm -rf '{}' +"
