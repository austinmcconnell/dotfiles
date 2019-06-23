#!/bin/sh

if ! is-executable git; then
  echo "**************************************************"
  echo "Skipping Git Configuration: Git not installed"
  echo "**************************************************"
  return
else
  echo "**************************************************"
  echo "Configuring Git"
  echo "**************************************************"
fi

mkdir ~/.git-templates

ln -sfv "$DOTFILES_DIR/etc/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/etc/git/.gitignore_global" ~
ln -sfv "$DOTFILES_DIR/etc/git/hooks" ~/.git-templates
