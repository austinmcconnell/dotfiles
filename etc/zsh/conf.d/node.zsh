#!/bin/zsh
#
# node.zsh - Node.js configurations and version management
#

##############################
# Environment Variables
##############################

# FNM (Fast Node Manager)
export FNM_PATH="$XDG_DATA_HOME/fnm"

# Initialize fnm if it exists
if [[ -d "$FNM_PATH" ]]; then
  export PATH="$FNM_PATH:$PATH"
  if command -v fnm >/dev/null; then
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
  fi
fi

# NPM configuration
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export NPM_CONFIG_FUND=false
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

# Add npm global binaries to PATH
if [[ -d "$XDG_DATA_HOME/npm/bin" ]]; then
  export PATH="$XDG_DATA_HOME/npm/bin:$PATH"
fi
