#!/bin/zsh
#
# 70-pyenv.zsh - Python version management
#

# Pyenv
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - --no-rehash zsh)"
