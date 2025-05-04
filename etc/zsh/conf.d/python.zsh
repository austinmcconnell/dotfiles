#!/bin/zsh
#
# python.zsh - Python configurations and aliases
#

##############################
# Environment Variables
##############################

# Pyenv
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

# PIPENV
export WORKON_HOME=~/.venvs
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
