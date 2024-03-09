#!/bin/bash

if is-executable zsh; then
    echo "**************************************************"
    echo "Configuring Zsh"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Zsh with brew"
        echo "**************************************************"
        brew install zsh
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Zsh with apt"
        echo "**************************************************"
        sudo apt update
        sudo apt install -y software-properties-common curl
        sudo add-apt-repository -y universe
        sudo apt install -y zsh
    else
        echo "**************************************************"
        echo "Skipping Zsh installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

ZDOTDIR="$HOME"/.config/zsh
mkdir -p "$ZDOTDIR"
echo "ZDOTDIR=${ZDOTDIR:-~/.config/zsh}" >"$HOME"/.zshenv
echo "source \$ZDOTDIR/.zshenv" >>"$HOME"/.zshenv

ln -sfv "$DOTFILES_DIR/etc/zsh/functions" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.aliases" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zlogin" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zprofile" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zsh_plugins.txt" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zshenv" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zshrc" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zstyles" "$ZDOTDIR"

mkdir -p "$HOME"/.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/tmux.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/tmux-256color.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/xterm-256color.terminfo

grep "$(which zsh)" /etc/shells &>/dev/null || sudo zsh -c "echo $(which zsh) >> /etc/shells"

if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)" "$USER"
fi

curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh

REPO_DIR="${ZDOTDIR:-$HOME}"/.antidote
if [ ! -d "$REPO_DIR/.git" ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$REPO_DIR"
fi
