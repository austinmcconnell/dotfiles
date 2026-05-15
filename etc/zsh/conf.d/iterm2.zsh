#!/bin/zsh
#
# iterm2.zsh - iTerm2 shell integration
#

# Load iTerm2 shell integration if it exists
if [[ -f "${HOME}/.iterm2_shell_integration.zsh" ]]; then
    source "${HOME}/.iterm2_shell_integration.zsh"
fi

# Set tab/window title to git repo basename or directory basename
function precmd_iterm2_title() {
    local dir
    dir=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
    echo -ne "\e]1;${dir:t}\a"
}
add-zsh-hook precmd precmd_iterm2_title
