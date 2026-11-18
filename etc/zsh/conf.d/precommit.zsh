#!/bin/zsh
#
# precommit.zsh - Nudge to run pre-commit autoupdate when hook revs are stale
#

function _check_precommit_stale() {
    [[ -f .pre-commit-config.yaml ]] || return
    (( $+commands[pre-commit] )) || return
    local last_rev_change
    last_rev_change=$(git log -1 --format=%ct -G'rev:' -- .pre-commit-config.yaml 2>/dev/null) || return
    [[ -n "$last_rev_change" ]] || return
    if (( $(date +%s) - last_rev_change > 90 * 86400 )); then
        echo "🔍 pre-commit revs last changed >90 days ago. Run \033[95mpre-commit autoupdate\033[0m to check."
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _check_precommit_stale

# Run on shell startup for the initial directory
_check_precommit_stale
