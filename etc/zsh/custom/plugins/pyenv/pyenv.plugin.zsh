#!/bin/zsh
#
# pyenv.plugin.zsh - Python version management
#

# Initialize pyenv if it exists
if [[ -d $PYENV_ROOT/bin ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"

  # Initialize pyenv with no rehashing for better performance
  eval "$(pyenv init - --no-rehash zsh)"
fi
