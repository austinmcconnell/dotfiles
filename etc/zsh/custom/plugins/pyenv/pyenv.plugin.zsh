#!/bin/zsh
#
# pyenv.plugin.zsh - Python version management
#

# Initialize pyenv
if [[ -d "$PYENV_ROOT" ]]; then
  # Add pyenv bin to PATH if it exists
  if [[ -d "$PYENV_ROOT/bin" ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
  fi

  # Initialize pyenv with no rehashing for better performance
  if command -v pyenv >/dev/null; then
    eval "$(pyenv init - --no-rehash zsh)"
  fi
fi
