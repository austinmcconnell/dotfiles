#!/bin/zsh
#
# ruby.zsh - Ruby configurations
#

##############################
# Environment Variables
##############################

# Add rbenv to PATH early to ensure it's available
if [[ -d "$RBENV_ROOT/bin" ]]; then
    export PATH="$RBENV_ROOT/bin:$PATH"
fi

# Initialize rbenv from a cached static file instead of spawning a subprocess
# Cache auto-invalidates when the rbenv binary changes (e.g., after brew upgrade)
if command -v rbenv >/dev/null; then
    local cache="$XDG_CACHE_HOME/zsh/rbenv-init.zsh"
    if [[ ! -s "$cache" || "${commands[rbenv]}" -nt "$cache" ]]; then
        mkdir -p "${cache:h}"
        rbenv init - --no-rehash zsh | sed '/^export PATH=/d' >| "$cache"
    fi
    path=("$RBENV_ROOT/shims" ${path:#$RBENV_ROOT/shims})
    source "$cache"
fi

# Ruby
export RUBY_CFLAGS=-DUSE_FFI_CLOSURE_ALLOC
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"
export GEMRC="$XDG_CONFIG_HOME/gem/gemrc"
# Workaround: rbs gem calls Pathname() without require "pathname".
# Remove when rbs ships fix: https://github.com/ruby/rbs/pull/2997
export RUBYOPT="-rpathname"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle/config"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle/plugin"
export RUBY_LSP_CONFIG_HOME="$XDG_CONFIG_HOME/ruby-lsp"
