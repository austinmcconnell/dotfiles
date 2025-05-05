#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# load zprof first if we need to profile
[[ ${ZSH_PROFILE_RC:-0} -eq 0 ]] || zmodload zsh/zprof

# Load zstyles
[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

# Load antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Set Zephyr home directory
export ZEPHYR_HOME=${ANTIDOTE_HOME:-$HOME/Library/Caches/antidote}/mattmc3/zephyr

# Source Zephyr - core functionality only, plugins will be loaded by Antidote
source $ZEPHYR_HOME/zephyr.zsh

# Generate static plugin file if needed
local bundle_file static_file
zstyle -s ':antidote:bundle' file bundle_file
zstyle -s ':antidote:static' file static_file

if [[ ! ${static_file} -nt ${bundle_file} ]]; then
  antidote bundle <${bundle_file} >|${static_file}  # Force overwrite with >|
fi

# Source the static plugins file
source ${static_file}

# Compile zsh files for faster loading
for file in ${ZDOTDIR:-~}/.zshrc ${ZDOTDIR:-~}/.zstyles ${ZDOTDIR:-~}/.zsh_plugins.zsh; do
  if [[ -f $file && ( ! -f ${file}.zwc || $file -nt ${file}.zwc ) ]]; then
    zcompile $file
  fi
done

# Compile conf.d files for faster loading
for file in ${ZDOTDIR:-~}/conf.d/*.zsh; do
  if [[ -f $file && ( ! -f ${file}.zwc || $file -nt ${file}.zwc ) ]]; then
    zcompile $file
  fi
done

# done profiling
[[ ${ZSH_PROFILE_RC:-0} -eq 0 ]] || { unset ZSH_PROFILE_RC && zprof }
