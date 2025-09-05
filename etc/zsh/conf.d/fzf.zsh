#!/bin/zsh
#
# fzf.zsh - FZF configurations and key bindings
#

##############################
# FZF Settings
##############################
export FZF_DEFAULT_COMMAND="fd --hidden --follow --color=always"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type directory"
export FZF_DEFAULT_OPTS="--ansi --color=dark --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B"
export FZF_CTRL_T_OPTS="--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

##############################
# FZF Integration
##############################

# Source fzf key bindings
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

# Source fzf completions (uncomment if needed)
# if [[ $- == *i* && -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
#   source /opt/homebrew/opt/fzf/shell/completion.zsh
# fi

# Custom key bindings for fzf
bindkey "^e" fzf-cd-widget

# Override fzf history widget to reload history first
fzf-history-widget-with-reload() {
  fc -R  # Reload history from file
  fzf-history-widget
}
zle -N fzf-history-widget-with-reload
bindkey '^r' fzf-history-widget-with-reload
