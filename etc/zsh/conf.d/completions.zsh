#!/bin/zsh
#
# completions.zsh - Completion system configuration and optimizations
#

##############################
# Completion Settings
##############################

# Load completions system
autoload -Uz compinit

# Only check completion dump once a day
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Load heavy completions only when needed
function load-docker-completion() {
  # Remove any existing docker completion
  compdef -d docker

  # Source docker completion if available
  if [[ -f /opt/homebrew/share/zsh/site-functions/_docker ]]; then
    source /opt/homebrew/share/zsh/site-functions/_docker
  fi
}

# Defer loading of heavy completions
if command -v zsh-defer >/dev/null; then
  zsh-defer load-docker-completion
fi

# Completion options
setopt COMPLETE_IN_WORD    # Complete from both ends of a word
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word
setopt AUTO_MENU           # Show completion menu on a successive tab press
setopt AUTO_LIST           # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash
setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
