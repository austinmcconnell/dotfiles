#!/bin/zsh
#
# filesystem.zsh - Filesystem aliases and configurations
#

##############################
# Filesystem Aliases
##############################
alias reload="exec zsh"
alias rr="rm -rf"
alias aliases="alias | sed 's/=.*//'"
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"
alias paths='echo -e ${PATH//:/\\n}'
alias df='df -H -l'
alias cleanupnode="find . -name 'node_modules' -exec rm -rf '{}' +"
alias please='sudo $(fc -ln -1)'
alias ls='gls'
alias ll='gls -lh'
alias la='gls -lha'
