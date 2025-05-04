#!/bin/zsh
#
# network.zsh - Networking aliases and configurations
#

##############################
# Networking Aliases
##############################
alias ip="curl -s ipinfo.io | jq -r '.ip'"
alias iplocal="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias speedtest="wget -O /dev/null http://speed.transip.nl/100mb.bin"

##############################
# HTTPie Aliases
##############################
alias https="http --default-scheme=https"
