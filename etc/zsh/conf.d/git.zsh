#!/bin/zsh
#
# git.zsh - Git aliases and configurations
#

##############################
# Version Control
##############################

# Delete branches that have been merged to trunk branch (usually main)
alias gdm='git branch --merged $(get_trunk_branch) | grep --extended-regexp --invert-match $(get_trunk_branch) | xargs --no-run-if-empty git branch --delete'
# Select files modified files to add/stage
alias ga='git ls-files --modified --others --exclude-standard | fzf --exit-0 --multi --preview "git diff --color=always {-1}" | xargs -o -t -r git add'
# Select files modified files to add/stage with patch
alias gap='git ls-files --modified --others --exclude-standard | fzf --exit-0 --multi --preview "git diff --color=always {-1}" | xargs -o -t -r git add --patch'
# Select branch to delete, excluding current
alias gbd='git branch | grep --extended-regexp --invert-match "$(git branch --show-current)" | fzf | xargs git branch --delete'
# Select branch to merge, excluding current
alias gbm='git branch | grep --extended-regexp --invert-match "$(git branch --show-current)" | fzf | xargs git merge'
# Select commit to fixup with already staged changes
alias gcf=get_fixup_commit
# Select branch to rebase onto, excluding current
alias gr='git branch --all | grep --extended-regexp --invert-match "HEAD|$(git branch --show-current)" | fzf | xargs git rebase --autostash'
# Select branch to interactively rebase onto, excluding current
alias gri='git branch --all | grep --extended-regexp --invert-match "HEAD|$(git branch --show-current)" | fzf | xargs -o git rebase --autostash --autosquash --interactive'
# Select branch to switch to, exclusing current
alias gsw='git branch --all | grep --extended-regexp --invert-match "HEAD|$(git branch --show-current)$" | fzf | sed "s#remotes/[^/]*/##" | xargs git switch'
