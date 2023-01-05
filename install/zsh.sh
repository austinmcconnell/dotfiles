#!/bin/sh

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

grep "$(which zsh)" /etc/shells &>/dev/null || sudo zsh -c "echo $(which zsh) >> /etc/shells"

if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh --shell $(which zsh) $USER
fi

REPO_DIR="$HOME/.repositories/oh-my-zsh"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    ZSH="$REPO_DIR" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    ln -sfv "$REPO_DIR" "$HOME/.oh-my-zsh"
fi

ln -sfv "$DOTFILES_DIR/runcom/.zshrc" ~
ln -sfv "$DOTFILES_DIR/etc/zsh/austin.zsh-theme" ~/.oh-my-zsh/custom/themes/

REPO_DIR="$HOME/.repositories/kube-ps1"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/jonmosco/kube-ps1.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.repositories/spaceship-prompt"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$REPO_DIR" --depth=1
    ln -sfv "$REPO_DIR" "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt"
    ln -sfv "$REPO_DIR/spaceship.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
fi

# if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt/.git" ] ; then
# git --work-tree="$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt" --git-dir="$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt/.git" pull origin master;
#else
# git clone https://github.com/superbrothers/zsh-kubectl-prompt.git "$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt"
# fi

# if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm/.git" ] ; then
# git --work-tree="$HOME/.oh-my-zsh/custom/plugins/zsh-nvm" --git-dir="$HOME/.oh-my-zsh/custom/plugins/zsh-nvm/.git" pull origin master;
# else
# git clone https://github.com/lukechilds/zsh-nvm "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm"
# fi

rm ~/.zcompdump*

# Setup terminfo
mkdir -p "$HOME"/.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/tmux.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/tmux-256color.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/xterm-256color.terminfo
