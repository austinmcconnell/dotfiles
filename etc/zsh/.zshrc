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
antidote load

# done profiling
[[ ${ZSH_PROFILE_RC:-0} -eq 0 ]] || {
    unset ZSH_PROFILE_RC
    zprof
}
