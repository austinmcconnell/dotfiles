#!/bin/zsh
#
# misc.zsh - Miscellaneous configurations and aliases
#

##############################
# Misc Aliases
##############################
alias zshrc='$EDITOR $ZDOTDIR/.zshrc'
alias hosts="sudo $EDITOR /etc/hosts"
alias ag='ag --hidden'
alias cat='cat_sleep $1'

##############################
# Profiling Aliases
##############################
alias zprofile="ZSH_PROFILE_RC=1 zsh"
alias zbench='for i in {1..10}; do /usr/bin/time zsh -lic exit; done'

##############################
# Other Environment Variables
##############################
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

# PostgreSQL
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_DATA_HOME/pg/psql_history"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"

# Terraform
export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraform/terraform.rc"

# .NET and NuGet
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export NUGET_PACKAGES="$XDG_DATA_HOME/nuget/packages"
export NUGET_HTTP_CACHE_PATH="$XDG_CACHE_HOME/nuget/http-cache"
export NUGET_PLUGINS_CACHE_PATH="$XDG_CACHE_HOME/nuget/plugins-cache"
export OMNISHARPHOME="$XDG_DATA_HOME/omnisharp"

# wget
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# fnm
export FNM_PATH="/Users/$(whoami)/.local/share/fnm"

# Kubernetes
export KUBE_PS1_SYMBOL_ENABLE=false
export KUBE_PS1_NS_COLOR=yellow
export KUBE_PS1_CTX_COLOR=yellow
export KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short

# zsh-abbr
export ABBR_USER_ABBREVIATIONS_FILE="$DOTFILES_DIR/etc/zsh/zsh-abbr/user-abbreviations"
