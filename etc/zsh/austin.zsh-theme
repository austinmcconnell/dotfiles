local user="%{$fg[blue]%}%n%{$reset_color%}"
local host="%{$fg[red]%}%M%{$reset_color%}"
local path_string="%{$fg[blue]%}%~%b%{$reset_color%}"

PROMPT='${user} on ${host} in ${path_string}$(git_prompt_info)
$ '
PROMPT='$(kube_ps1)'$PROMPT

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"

# Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"

# Text to display if the branch is clean
ZSH_THEME_GIT_PROMPT_CLEAN=""
