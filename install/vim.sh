#!/bin/bash

if ! is-executable vim; then
    echo "**************************************************"
    echo "Skipping Vim configuration: vim not found"
    echo "**************************************************"
    return
fi

echo "**************************************************"
echo "Configuring Vim"
echo "**************************************************"

# ctags and the_silver_searcher installed via vim.Brewfile

VIM_DIR="$HOME/.vim"

mkdir -p "$VIM_DIR"/spell
mkdir -p "$VIM_DIR"/undodir
mkdir -p "$XDG_CONFIG_HOME/yamllint/"

ln -sfv "$DOTFILES_DIR/etc/vim/after" "$VIM_DIR"
ln -sfv "$DOTFILES_DIR/etc/vim/plugin" "$VIM_DIR"
ln -sfv "$DOTFILES_DIR/etc/vim/syntax" "$VIM_DIR"
ln -sfv "$DOTFILES_DIR/etc/vim/filetype.vim" "$VIM_DIR"
ln -sfv "$DOTFILES_DIR/etc/vim/.vimrc" "$VIM_DIR/vimrc"
ln -sfv "$DOTFILES_DIR/etc/vim/.ctags" "$HOME/.ctags"
ln -sfv "$DOTFILES_DIR/etc/ag/.agignore" "$HOME/.agignore"
ln -sfv "$DOTFILES_DIR/etc/yaml/yamllint" "$XDG_CONFIG_HOME/yamllint/config"
