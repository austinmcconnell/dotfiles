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
mkdir -p ~/.vim/pack/bundle/start
mkdir -p ~/.vim/pack/bundle/opt

ln -sfv "$DOTFILES_DIR/runcom/.vimrc" ~

if [ ! -f "$HOME/.vim/colors/darcula.vim" ] ; then
  curl --create-dirs --output "$HOME/.vim/colors/darcula.vim" https://raw.githubusercontent.com/blueshirts/darcula/master/colors/darcula.vim
fi

## Add plugins
if [ -d "$HOME/.vim/pack/bundle/start/auto-pairs/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/auto-pairs" --git-dir="$HOME/.vim/pack/bundle/start/auto-pairs/.git" pull origin master;
else
  git clone git@github.com:jiangmiao/auto-pairs.git $HOME/.vim/pack/bundle/start/auto-pairs
fi

if [ -d "$HOME/.vim/pack/bundle/start/nerdtree/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/nerdtree" --git-dir="$HOME/.vim/pack/bundle/start/nerdtree/.git" pull origin master;
else
  git clone git@github.com:scrooloose/nerdtree.git $HOME/.vim/pack/bundle/start/nerdtree
fi

if [ -d "$HOME/.vim/pack/bundle/start/jedi-vim/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/jedi-vim" --git-dir="$HOME/.vim/pack/bundle/start/jedi-vim/.git" pull origin master;
  (cd "$HOME/.vim/pack/bundle/start/jedi-vim" && git submodule update --init --recursive;)
else
  git clone git@github.com:davidhalter/jedi-vim.git $HOME/.vim/pack/bundle/start/jedi-vim
  (cd "$HOME/.vim/pack/bundle/start/jedi-vim" && git submodule update --init --recursive;)
fi

if [ -d "$HOME/.vim/pack/bundle/start/supertab/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/supertab" --git-dir="$HOME/.vim/pack/bundle/start/supertab/.git" pull origin master;
else
  git clone git@github.com:ervandew/supertab.git $HOME/.vim/pack/bundle/start/supertab
fi
https://github.com/ervandew/supertab
