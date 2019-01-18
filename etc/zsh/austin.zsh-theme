local user="%{$fg[blue]%}%n%{$reset_color%}"
local host="%{$fg[red]%}%M%{$reset_color%}"
local path_string="%{$fg[blue]%}%~%b%{$reset_color%}"
local battery_string='$(battery -z -p)%{$reset_color%}'
local kubernetes_string='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

PROMPT='${user} on ${host} in ${path_string}$(git_time_since_commit)$(check_git_prompt_info)
$ '
# $(kubecontext)$(gcloudproject)
RPROMPT="${kubernetes_string}${battery_string}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

# Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"

# Text to display if the branch is clean
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"


# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ -z $(git_prompt_info) ]]; then
            echo "%{$fg[magenta]%}detached-head%{$reset_color%})"
        else
            echo "$(git_prompt_info)"
        fi
    fi
}

# Determine if we are using a gemset.
function rvm_gemset() {
    if hash rvm 2>/dev/null; then
        GEMSET=`rvm gemset list | grep '=>' | cut -b4-`
        if [[ -n $GEMSET ]]; then
            echo "%{$fg[yellow]%}$GEMSET%{$reset_color%}|"
        fi
    fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))

            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))

            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "($(rvm_gemset)$COLOR${DAYS}d ${SUB_HOURS}h ${SUB_MINUTES}m%{$reset_color%}|"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "($(rvm_gemset)$COLOR${HOURS}h ${SUB_MINUTES}m %{$reset_color%}|"
            else
                echo "($(rvm_gemset)$COLOR${MINUTES}m%{$reset_color%}|"
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "($(rvm_gemset)$COLOR~|"
        fi
    fi
}

# Add kubernetes context to prompt
function kubecontext() {
    if [[ $(kubectl config current-context) == *"sandbox"* ]]; then
        echo "\nkubernetes: %{$fg[green]%}sandbox%{$reset_color%}"
    elif [[ $(kubectl config current-context) == *"staging"* ]]; then
        echo "\nkubernetes: %{$fg[yellow]%}staging%{$reset_color%}"
    elif [[ $(kubectl config current-context) == *"prod"* ]]; then
        echo "\nkubernetes: %{$fg[red]%}production%{$reset_color%}"
  fi
}

# Add gcloud project to prompt
function gcloudproject() {
    if [[ $(gcloud config list --format 'value(core.project)') == *"sandbox"* ]]; then
        echo "  gcloud: %{$fg[green]%}sandbox%{$reset_color%}"
    elif [[ $(gcloud config list --format 'value(core.project)') == *"staging"* ]]; then
        echo "  gcloud: %{$fg[yellow]%}staging%{$reset_color%}"
    elif [[ $(gcloud config list --format 'value(core.project)') == *"prod"* ]]; then
        echo "  gcloud: %{$fg[red]%}production%{$reset_color%}"
  fi
}
