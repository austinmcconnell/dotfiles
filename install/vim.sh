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
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Vim"
        echo "**************************************************"
        sudo apt update
        sudo apt install -y vim
    else
        echo "**************************************************"
        echo "Skipping Vim installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

if is-macos; then
    brew install ctags the_silver_searcher
elif is-debian; then
    sudo apt update
    sudo apt install -y ctags silversearcher-ag
fi

touch ~/.vimrc
mkdir -p ~/.vim/pack/bundle/start
mkdir -p ~/.vim/pack/bundle/opt
mkdir -p ~/.vim/spell
mkdir -p ~/.vim/undodir
mkdir -p ~/.config/yamllint/

ln -sfv "$DOTFILES_DIR/etc/vim/ftplugin" ~/.vim
ln -sfv "$DOTFILES_DIR/etc/vim/plugin" ~/.vim
ln -sfv "$DOTFILES_DIR/runcom/.vimrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.ctags" ~
ln -sfv "$DOTFILES_DIR/etc/yaml/yamllint" ~/.config/yamllint/config

## Add colorschemes
REPO_DIR="$HOME/.vim/colors/darcula"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/blueshirts/darcula "$REPO_DIR"
    ln -sfv "$REPO_DIR/colors/darcula.vim" "$HOME/.vim/colors/darcula.vim"
fi

REPO_DIR="$HOME/.vim/colors/solarized"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/altercation/vim-colors-solarized "$REPO_DIR"
    ln -sfv "$REPO_DIR/colors/solarized.vim" "$HOME/.vim/colors/solarized.vim"
fi

REPO_DIR="$HOME/.vim/colors/nord"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin develop
else
    git clone https://github.com/arcticicestudio/nord-vim "$REPO_DIR"
    ln -sfv "$REPO_DIR/colors/nord.vim" "$HOME/.vim/colors/nord.vim"
fi

## Add plugins
REPO_DIR="$HOME/.vim/pack/bundle/start/auto-pairs"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/jiangmiao/auto-pairs.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/nerdtree"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/preservim/nerdtree.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/nerdtree-git"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/tagbar"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/majutsushi/tagbar.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/gitgutter"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/airblade/vim-gitgutter.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/lightline"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/itchyny/lightline.vim.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/fugitive"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/tpope/vim-fugitive.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/gutentags"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/ludovicchabant/vim-gutentags.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/ale"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/w0rp/ale.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/lightline-ale"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/maximbaz/lightline-ale.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/goyo"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/junegunn/goyo.vim.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/limelight"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/junegunn/limelight.vim.git "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/undotree"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/mbbill/undotree "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/buftabline"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/ap/vim-buftabline "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/grepper"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/mhinz/vim-grepper "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/hardtime"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/takac/vim-hardtime "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/indentline"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/Yggdroot/indentLine "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/yaml-folds"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/pedrohdz/vim-yaml-folds "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/list-toggle"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/Valloric/ListToggle "$REPO_DIR"
fi

REPO_DIR="$HOME/.vim/pack/bundle/start/supertab"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/ervandew/supertab "$REPO_DIR"
fi
