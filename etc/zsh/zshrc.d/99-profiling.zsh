#!/bin/zsh
#
# 99-profiling.zsh - End profiling if enabled
#

# done profiling
[[ ${ZSH_PROFILE_RC:-0} -eq 0 ]] || { unset ZSH_PROFILE_RC && zprof }
