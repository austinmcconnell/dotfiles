#!/bin/sh

mkdir ~/.git-templates

ln -sfv "$DOTFILES_DIR/etc/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/etc/git/.gitignore_global" ~
ln -sfv "$DOTFILES_DIR/etc/git/hooks" ~/.git-templates
