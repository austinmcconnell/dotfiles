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

ZDOTDIR="$XDG_CONFIG_HOME/zsh"
ZSH_COMPLETIONS_DIR="$ZDOTDIR/completions"
ITERM_COLORSCHEME_DIR="$DOTFILES_DIR/etc/iterm/colorschemes"

mkdir -p "$ZDOTDIR"
mkdir -p "$ZDOTDIR/zshrc.d"
mkdir -p "$ZDOTDIR/custom/plugins/extra"
mkdir -p "$ZSH_COMPLETIONS_DIR"
mkdir -p "$XDG_CONFIG_HOME"/spaceship
mkdir -p "$XDG_CONFIG_HOME"/direnv
mkdir -p "$ITERM_COLORSCHEME_DIR"

echo "ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}" >"$HOME"/.zshenv
echo "source \$ZDOTDIR/.zshenv" >>"$HOME"/.zshenv

# Link main configuration files
ln -sfv "$DOTFILES_DIR/etc/zsh/functions" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.aliases" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zlogin" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zprofile" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zsh_plugins.txt" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zshenv" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zshrc" "$ZDOTDIR"
ln -sfv "$DOTFILES_DIR/etc/zsh/.zstyles" "$ZDOTDIR"

# Link custom plugins
ln -sfv "$DOTFILES_DIR/etc/zsh/custom/plugins/extra/extra.plugin.zsh" "$ZDOTDIR/custom/plugins/extra/extra.plugin.zsh"

# Link modular configuration files
for config_file in "$DOTFILES_DIR/etc/zsh/zshrc.d"/*.zsh; do
    if [ -f "$config_file" ]; then
        ln -sfv "$config_file" "$ZDOTDIR/zshrc.d/$(basename "$config_file")"
    fi
done

# Link other configuration files
ln -sfv "$DOTFILES_DIR/etc/spaceship/spaceship.zsh" "$XDG_CONFIG_HOME"/spaceship/spaceship.zsh
ln -sfv "$DOTFILES_DIR/etc/starship/starship.toml" "$XDG_CONFIG_HOME"
ln -sfv "$DOTFILES_DIR/etc/direnv/direnv.toml" "$XDG_CONFIG_HOME"/direnv

# Setup terminfo
mkdir -p "$HOME"/.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/tmux.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/tmux-256color.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/xterm-256color.terminfo

# Set zsh as default shell
grep "$(which zsh)" /etc/shells &>/dev/null || sudo zsh -c "echo $(which zsh) >> /etc/shells"

if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)" "$USER"
fi

# Install iTerm2 shell integration
if [ ! -f "$HOME/.iterm2_shell_integration.zsh" ]; then
    curl -L https://iterm2.com/shell_integration/zsh -o "$HOME/.iterm2_shell_integration.zsh"
fi

# Install antidote plugin manager
REPO_DIR="${ZDOTDIR:-$HOME}"/.antidote
if [ ! -d "$REPO_DIR/.git" ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$REPO_DIR"
    chmod +x "$REPO_DIR/antidote"
    mkdir -p "$ZDOTDIR/completions"
fi

# Install iTerm2 color schemes
iterm_colorschemes=(
    https://raw.githubusercontent.com/nordtheme/iterm2/233a2462e04e07a9676386a52dad0c2ff6666d72/src/xml/Nord.itermcolors
    https://raw.githubusercontent.com/rose-pine/iterm/main/rose-pine.itermcolors
    https://raw.githubusercontent.com/rose-pine/iterm/main/rose-pine-moon.itermcolors
    https://raw.githubusercontent.com/icewind/everforest.iterm2/main/themes/everforest_dark_medium.itermcolors
    https://raw.githubusercontent.com/icewind/everforest.iterm2/main/themes/everforest_light_low.itermcolors
)

for repo in "${iterm_colorschemes[@]}"; do
    colorscheme=$(echo "$repo" | rev | cut -d '/' -f 1 | rev)
    if [ ! -f "$ITERM_COLORSCHEME_DIR/$colorscheme" ]; then
        curl --location --silent "$repo" >"$ITERM_COLORSCHEME_DIR/$colorscheme"
        open "$ITERM_COLORSCHEME_DIR/$colorscheme"
    fi
done

# Docker completions
if is-executable docker; then
    docker completion zsh >"$ZSH_COMPLETIONS_DIR/_docker"
fi
