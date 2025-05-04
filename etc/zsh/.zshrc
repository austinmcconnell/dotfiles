#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# load zprof first if we need to profile
[[ ${ZSH_PROFILE_RC:-0} -eq 0 ]] || zmodload zsh/zprof

[[ -e ${ZDOTDIR:-~}/.zstyles ]] && source ${ZDOTDIR:-~}/.zstyles

# Load all files from zshrc.d directory
for config_file ($ZDOTDIR/zshrc.d/*.zsh(N)); do
    source $config_file
done
