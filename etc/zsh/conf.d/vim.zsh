#!/bin/zsh
#
# vim.zsh - Vim aliases and configurations
#

##############################
# Vim Aliases
##############################
alias vanillavim='vim --noplugins -u NONE'
alias vimrc='$EDITOR ~/.vimrc'
alias mods='vim $((git ls-files --modified --others --exclude-standard && git diff --name-only --cached) | sort -u)'
