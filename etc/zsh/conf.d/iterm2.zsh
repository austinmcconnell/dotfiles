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
    # OSC 0 sets BOTH icon/session title and window title. iTerm2 maps the
    # icon title to the Session Name (shown as the tab title by default);
    # Ghostty sets the window title. OSC 2 (window title only) would NOT
    # update iTerm2's tab, and OSC 1 (icon only) is ignored by Ghostty.
    # Under Ghostty this hook is the SOLE title source: the config sets
    # shell-integration-features = ...,no-title so Ghostty's own integration
    # does not also set (and race) the title each prompt.
    echo -ne "\e]0;${dir:t}\a"
}
add-zsh-hook precmd precmd_iterm2_title
