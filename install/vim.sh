#!/bin/sh

if is-executable vim; then
  echo "**************************************************"
  echo "Configuring Vim"
  echo "**************************************************"
else
  if is-macos; then
    echo "**************************************************"
    echo "Installing Vim"
    echo "**************************************************"
    brew install vim
    brew install ctags
  elif is-debian; then
    echo "**************************************************"
    echo "Installing Vim"
    echo "**************************************************"
    sudo add-apt-repository -y ppa:jonathonf/vim
    sudo apt update
    sudo apt install -y vim ctags
  else
    echo "**************************************************"
    echo "Skipping Vim installation: Unidentified OS"
    echo "**************************************************"
    return
  fi
fi

touch ~/.vimrc
mkdir -p ~/.vim/pack/bundle/start
mkdir -p ~/.vim/pack/bundle/opt
mkdir -p ~/.vim/spell
mkdir -p ~/.vim/undodir

ln -sfv "$DOTFILES_DIR/etc/vim/ftplugin" ~/.vim
ln -sfv "$DOTFILES_DIR/runcom/.vimrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.ctags" ~

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
  git clone https://github.com/jiangmiao/auto-pairs.git "$HOME/.vim/pack/bundle/start/auto-pairs"
fi

if [ -d "$HOME/.vim/pack/bundle/start/nerdtree/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/nerdtree" --git-dir="$HOME/.vim/pack/bundle/start/nerdtree/.git" pull origin master;
else
  git clone https://github.com/scrooloose/nerdtree.git "$HOME/.vim/pack/bundle/start/nerdtree"
fi

if [ -d "$HOME/.vim/pack/bundle/start/jedi-vim/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/jedi-vim" --git-dir="$HOME/.vim/pack/bundle/start/jedi-vim/.git" pull origin master;
  (cd "$HOME/.vim/pack/bundle/start/jedi-vim" && git submodule update --init --recursive;)
else
  git clone https://github.com/davidhalter/jedi-vim.git "$HOME/.vim/pack/bundle/start/jedi-vim"
  (cd "$HOME/.vim/pack/bundle/start/jedi-vim" && git submodule update --init --recursive;)
fi

if [ -d "$HOME/.vim/pack/bundle/start/supertab/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/supertab" --git-dir="$HOME/.vim/pack/bundle/start/supertab/.git" pull origin master;
else
  git clone https://github.com/ervandew/supertab.git "$HOME/.vim/pack/bundle/start/supertab"
fi

if [ -d "$HOME/.vim/pack/bundle/start/tagbar/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/tagbar" --git-dir="$HOME/.vim/pack/bundle/start/tagbar/.git" pull origin master;
else
  git clone https://github.com/majutsushi/tagbar.git "$HOME/.vim/pack/bundle/start/tagbar"
fi

if [ -d "$HOME/.vim/pack/bundle/start/gitgutter/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/gitgutter" --git-dir="$HOME/.vim/pack/bundle/start/gitgutter/.git" pull origin master;
else
  git clone https://github.com/airblade/vim-gitgutter.git "$HOME/.vim/pack/bundle/start/gitgutter"
fi

if [ -d "$HOME/.vim/pack/bundle/start/lightline/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/lightline" --git-dir="$HOME/.vim/pack/bundle/start/lightline/.git" pull origin master;
else
  git clone https://github.com/itchyny/lightline.vim.git "$HOME/.vim/pack/bundle/start/lightline"
fi

if [ -d "$HOME/.vim/pack/bundle/start/fugitive/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/fugitive" --git-dir="$HOME/.vim/pack/bundle/start/fugitive/.git" pull origin master;
else
  git clone https://github.com/tpope/vim-fugitive.git "$HOME/.vim/pack/bundle/start/fugitive"
fi

if [ -d "$HOME/.vim/pack/bundle/start/gutentags/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/gutentags" --git-dir="$HOME/.vim/pack/bundle/start/gutentags/.git" pull origin master;
else
  git clone https://github.com/ludovicchabant/vim-gutentags.git "$HOME/.vim/pack/bundle/start/gutentags"
fi

if [ -d "$HOME/.vim/pack/bundle/start/ale/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/ale" --git-dir="$HOME/.vim/pack/bundle/start/ale/.git" pull origin master;
else
  git clone https://github.com/w0rp/ale.git "$HOME/.vim/pack/bundle/start/ale"
fi

if [ -d "$HOME/.vim/pack/bundle/start/lightline-ale/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/lightline-ale" --git-dir="$HOME/.vim/pack/bundle/start/lightline-ale/.git" pull origin master;
else
  git clone https://github.com/maximbaz/lightline-ale.git "$HOME/.vim/pack/bundle/start/lightline-ale"
fi

if [ -d "$HOME/.vim/pack/bundle/start/goyo/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/goyo" --git-dir="$HOME/.vim/pack/bundle/start/goyo/.git" pull origin master;
else
  git clone https://github.com/junegunn/goyo.vim.git "$HOME/.vim/pack/bundle/start/goyo"
fi

if [ -d "$HOME/.vim/pack/bundle/start/limelight/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/limelight" --git-dir="$HOME/.vim/pack/bundle/start/limelight/.git" pull origin master;
else
  git clone https://github.com/junegunn/limelight.vim.git "$HOME/.vim/pack/bundle/start/limelight"
fi

if [ -d "$HOME/.vim/pack/bundle/start/ack/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/ack" --git-dir="$HOME/.vim/pack/bundle/start/ack/.git" pull origin master;
else
  git clone https://github.com/mileszs/ack.vim.git "$HOME/.vim/pack/bundle/start/ack"
fi

if [ -d "$HOME/.vim/pack/bundle/start/wiki/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/wiki" --git-dir="$HOME/.vim/pack/bundle/start/wiki/.git" pull origin master;
else
  git clone https://github.com/vimwiki/vimwiki.git "$HOME/.vim/pack/bundle/start/wiki"
fi

if [ -d "$HOME/.vim/pack/bundle/start/autosave/.git" ] ; then
	git --work-tree="$HOME/.vim/pack/bundle/start/autosave" --git-dir="$HOME/.vim/pack/bundle/start/autosave/.git" pull origin master;
else
  git clone https://github.com/907th/vim-auto-save "$HOME/.vim/pack/bundle/start/autosave"
fi
