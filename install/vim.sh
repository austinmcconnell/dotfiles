#!/bin/sh

if ! is-executable brew; then
  echo "**************************************************"
  echo "Skipping Vim Installs: Homebrew not installed"
  echo "**************************************************"
  return
else
  echo "**************************************************"
  echo "Installing Vim packages"
  echo "**************************************************"
fi

brew install vim

touch ~/.vimrc

ln -sfv "$DOTFILES_DIR/runcom/.vimrc" ~

if [ ! -f "$HOME/.vim/colors/darcula.vim" ] ; then
  curl --create-dirs --output "$HOME/.vim/colors/darcula.vim" https://raw.githubusercontent.com/blueshirts/darcula/master/colors/darcula.vim
fi
