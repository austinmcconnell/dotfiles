#!/bin/zsh
#
# ruby.zsh - Ruby configurations
#

##############################
# Environment Variables
##############################

# rbenv
export RBENV_ROOT="$XDG_DATA_HOME/rbenv"

# Ruby
export RUBY_CFLAGS=-DUSE_FFI_CLOSURE_ALLOC
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem/specs"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle/config"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle/plugin"
export RUBY_LSP_CONFIG_HOME="$XDG_CONFIG_HOME/ruby-lsp"
