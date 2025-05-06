#!/bin/zsh
#
# dircolors.zsh - Configure dircolors for terminal
#

# Set Nord dircolors as default color theme
test -r ~/.dir_colors && eval "$(dircolors ~/.dir_colors)"
