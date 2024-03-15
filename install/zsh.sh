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
        brew install zsh starship
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
ITERM_COLORSCHEME_DIR="$DOTFILES_DIR/etc/iterm/colorschemes"

mkdir -p "$ZDOTDIR"
mkdir -p "$XDG_CONFIG_HOME"/spaceship
mkdir -p "$ITERM_COLORSCHEME_DIR"

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
ln -sfv "$DOTFILES_DIR/etc/spaceship/spaceship.zsh" "$XDG_CONFIG_HOME"/spaceship/spaceship.zsh
ln -sfv "$DOTFILES_DIR/etc/starship/starship.toml" "$XDG_CONFIG_HOME"

mkdir -p "$HOME"/.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/tmux.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/tmux-256color.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/xterm-256color.terminfo

grep "$(which zsh)" /etc/shells &>/dev/null || sudo zsh -c "echo $(which zsh) >> /etc/shells"

if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)" "$USER"
fi

if [ ! -f "$HOME/.iterm2_shell_integration.zsh" ]; then
    curl -L https://iterm2.com/shell_integration/zsh -o "$HOME/.iterm2_shell_integration.zsh"
fi

REPO_DIR="${ZDOTDIR:-$HOME}"/.antidote
if [ ! -d "$REPO_DIR/.git" ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$REPO_DIR"
fi

iterm_colorschemes=(
    https://raw.githubusercontent.com/nordtheme/iterm2/233a2462e04e07a9676386a52dad0c2ff6666d72/src/xml/Nord.itermcolors
    https://raw.githubusercontent.com/rose-pine/iterm/main/rose-pine.itermcolors
    https://raw.githubusercontent.com/rose-pine/iterm/main/rose-pine-moon.itermcolors
)

for repo in "${iterm_colorschemes[@]}"; do
    colorscheme=$(echo "$repo" | rev | cut -d '/' -f 1 | rev)
    if [ ! -f "$ITERM_COLORSCHEME_DIR/$colorscheme" ]; then
        curl --location --silent "$repo" >"$ITERM_COLORSCHEME_DIR/$colorscheme"
        open "$ITERM_COLORSCHEME_DIR/$colorscheme"
    fi
done
