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
mkdir -p ~/.vim/spell

ln -sfv "$DOTFILES_DIR/etc/vim/ftplugin" ~/.vim

ln -sfv "$DOTFILES_DIR/runcom/.vimrc" ~

if [ ! -f "$HOME/.vim/colors/darcula.vim" ] ; then
  curl --create-dirs --output "$HOME/.vim/colors/darcula.vim" https://raw.githubusercontent.com/blueshirts/darcula/master/colors/darcula.vim
fi

if [ ! -f "$HOME/.vim/colors/solarized.vim" ] ; then
  curl --create-dirs --output "$HOME/.vim/colors/solarized.vim" https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim
fi

## Add plugins
if [ -d "$HOME/.vim/pack/bundle/start/auto-pairs/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/auto-pairs" --git-dir="$HOME/.vim/pack/bundle/start/auto-pairs/.git" pull origin master;
else
  git clone git@github.com:jiangmiao/auto-pairs.git "$HOME/.vim/pack/bundle/start/auto-pairs"
fi

if [ -d "$HOME/.vim/pack/bundle/start/nerdtree/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/nerdtree" --git-dir="$HOME/.vim/pack/bundle/start/nerdtree/.git" pull origin master;
else
  git clone git@github.com:scrooloose/nerdtree.git "$HOME/.vim/pack/bundle/start/nerdtree"
fi

if [ -d "$HOME/.vim/pack/bundle/start/jedi-vim/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/jedi-vim" --git-dir="$HOME/.vim/pack/bundle/start/jedi-vim/.git" pull origin master;
  (cd "$HOME/.vim/pack/bundle/start/jedi-vim" && git submodule update --init --recursive;)
else
  git clone git@github.com:davidhalter/jedi-vim.git "$HOME/.vim/pack/bundle/start/jedi-vim"
  (cd "$HOME/.vim/pack/bundle/start/jedi-vim" && git submodule update --init --recursive;)
fi

if [ -d "$HOME/.vim/pack/bundle/start/supertab/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/supertab" --git-dir="$HOME/.vim/pack/bundle/start/supertab/.git" pull origin master;
else
  git clone git@github.com:ervandew/supertab.git "$HOME/.vim/pack/bundle/start/supertab"
fi

if [ -d "$HOME/.vim/pack/bundle/start/tagbar/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/tagbar" --git-dir="$HOME/.vim/pack/bundle/start/tagbar/.git" pull origin master;
else
  git clone git@github.com:majutsushi/tagbar.git "$HOME/.vim/pack/bundle/start/tagbar"
fi

if [ -d "$HOME/.vim/pack/bundle/start/gitgutter/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/gitgutter" --git-dir="$HOME/.vim/pack/bundle/start/gitgutter/.git" pull origin master;
else
  git clone git@github.com:airblade/vim-gitgutter.git "$HOME/.vim/pack/bundle/start/gitgutter"
fi

if [ -d "$HOME/.vim/pack/bundle/start/lightline/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/lightline" --git-dir="$HOME/.vim/pack/bundle/start/lightline/.git" pull origin master;
else
  git clone git@github.com:itchyny/lightline.vim.git "$HOME/.vim/pack/bundle/start/lightline"
fi

if [ -d "$HOME/.vim/pack/bundle/start/fugitive/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/fugitive" --git-dir="$HOME/.vim/pack/bundle/start/fugitive/.git" pull origin master;
else
  git clone git@github.com:tpope/vim-fugitive.git "$HOME/.vim/pack/bundle/start/fugitive"
fi

if [ -d "$HOME/.vim/pack/bundle/start/gutentags/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/gutentags" --git-dir="$HOME/.vim/pack/bundle/start/gutentags/.git" pull origin master;
else
  git clone git@github.com:ludovicchabant/vim-gutentags.git "$HOME/.vim/pack/bundle/start/gutentags"
fi

if [ -d "$HOME/.vim/pack/bundle/start/ale/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/ale" --git-dir="$HOME/.vim/pack/bundle/start/ale/.git" pull origin master;
else
  git clone git@github.com:w0rp/ale.git "$HOME/.vim/pack/bundle/start/ale"
fi

if [ -d "$HOME/.vim/pack/bundle/start/lightline-ale/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/lightline-ale" --git-dir="$HOME/.vim/pack/bundle/start/lightline-ale/.git" pull origin master;
else
  git clone git@github.com:maximbaz/lightline-ale.git "$HOME/.vim/pack/bundle/start/lightline-ale"
fi

if [ -d "$HOME/.vim/pack/bundle/start/goyo/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/goyo" --git-dir="$HOME/.vim/pack/bundle/start/goyo/.git" pull origin master;
else
  git clone git@github.com:junegunn/goyo.vim.git "$HOME/.vim/pack/bundle/start/goyo"
fi

if [ -d "$HOME/.vim/pack/bundle/start/limelight/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/limelight" --git-dir="$HOME/.vim/pack/bundle/start/limelight/.git" pull origin master;
else
  git clone git@github.com:junegunn/limelight.vim.git "$HOME/.vim/pack/bundle/start/limelight"
fi

if [ -d "$HOME/.vim/pack/bundle/start/ack/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/ack" --git-dir="$HOME/.vim/pack/bundle/start/ack/.git" pull origin master;
else
  git clone git@github.com:mileszs/ack.vim.git "$HOME/.vim/pack/bundle/start/ack"
fi

if [ -d "$HOME/.vim/pack/bundle/start/wiki/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/wiki" --git-dir="$HOME/.vim/pack/bundle/start/wiki/.git" pull origin master;
else
  git clone git@github.com:vimwiki/vimwiki.git "$HOME/.vim/pack/bundle/start/wiki"
fi
