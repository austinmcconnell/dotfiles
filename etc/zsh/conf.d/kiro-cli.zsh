#!/bin/zsh
#
# Kiro CLI shell integration
#

case "${1:-both}" in
  pre)
    [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && \
      builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
    ;;
  post)
    [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && \
      builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
    ;;
  both)
    [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && \
      builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
    [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && \
      builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
    ;;
esac
