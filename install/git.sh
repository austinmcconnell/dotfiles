#!/bin/sh

if is-executable git; then
    echo "**************************************************"
    echo "Configuring Git"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Git with brew"
        echo "**************************************************"
        brew install git
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Git with apt"
        echo "**************************************************"
        sudo apt install git
    else
        echo "**************************************************"
        echo "Skipping Git installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

mkdir -p ~/.git-templates/hooks

ln -sfv "$DOTFILES_DIR/etc/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/etc/git/.gitignore_global" ~
ln -sfv "$DOTFILES_DIR/etc/git/hooks/pre-push" ~/.git-templates/hooks/pre-push
ln -sfv "$DOTFILES_DIR/etc/git/.gitconfig-uniteus" ~

if is-macos; then
    ln -sfv "$DOTFILES_DIR/etc/git/.gitconfig-macos" ~
elif is-debian; then
    ln -sfv "$DOTFILES_DIR/etc/git/.gitconfig-linux" ~
fi

if [ -d "$HOME/.repositories/diff-so-fancy/.git" ]; then
    git --work-tree="$HOME/.repositories/diff-so-fancy/" --git-dir="$HOME/.repositories/diff-so-fancy/.git" pull origin master
else
    git clone https://github.com/so-fancy/diff-so-fancy "$HOME/.repositories/diff-so-fancy/"
    sudo ln -sfv "$HOME/.repositories/diff-so-fancy/diff-so-fancy" /usr/local/bin/
fi
