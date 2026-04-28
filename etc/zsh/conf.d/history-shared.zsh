# Override zephyr history defaults to enable shared history
setopt share_history
unsetopt inc_append_history

# Keep full command timeline for troubleshooting/auditing.
# hist_find_no_dups (kept from Zephyr defaults) ensures built-in
# zsh search widgets still skip duplicates.
unsetopt hist_ignore_all_dups
unsetopt hist_save_no_dups
unsetopt hist_ignore_dups
