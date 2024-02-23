#!/bin/bash

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

mkdir -p ~/.vim/colors
mkdir -p ~/.vim/pack/bundle/start
mkdir -p ~/.vim/pack/bundle/opt
mkdir -p ~/.vim/spell
mkdir -p ~/.vim/undodir
mkdir -p ~/.config/yamllint/

ln -sfv "$DOTFILES_DIR/etc/vim/ftplugin" ~/.vim
ln -sfv "$DOTFILES_DIR/etc/vim/plugin" ~/.vim
ln -sfv "$DOTFILES_DIR/etc/vim/.vimrc" ~
ln -sfv "$DOTFILES_DIR/etc/vim/.ctags" ~
ln -sfv "$DOTFILES_DIR/etc/ag/.agignore" ~
ln -sfv "$DOTFILES_DIR/etc/yaml/yamllint" ~/.config/yamllint/config

## Add colorschemes
REPO_DIR="$HOME/.repositories/darcula"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/blueshirts/darcula "$REPO_DIR"
    ln -sfv "$REPO_DIR/colors/darcula.vim" "$HOME/.vim/colors/darcula.vim"
fi

REPO_DIR="$HOME/.repositories/solarized"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/altercation/vim-colors-solarized "$REPO_DIR"
    ln -sfv "$REPO_DIR/colors/solarized.vim" "$HOME/.vim/colors/solarized.vim"
fi

REPO_DIR="$HOME/.repositories/nord-vim"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin main
else
    git clone https://github.com/nordtheme/vim "$REPO_DIR"
    ln -sfv "$REPO_DIR/colors/nord.vim" "$HOME/.vim/colors/nord.vim"
fi

REPO_DIR="$HOME/.repositories/nord-dircolors"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin main
else
    git clone https://github.com/nordtheme/dircolors "$REPO_DIR"
    ln -sfv "$REPO_DIR/src/dir_colors" "$HOME/.dir_colors"
fi
#
## Add plugins
REPO_DIR="$HOME/.repositories/auto-pairs"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/jiangmiao/auto-pairs.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/auto-pairs"
fi

REPO_DIR="$HOME/.repositories/nerdtree"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/preservim/nerdtree.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/nerdtree"
fi

REPO_DIR="$HOME/.repositories/nerdtree-git"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/nerdtree-git"
fi

REPO_DIR="$HOME/.repositories/tagbar"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/majutsushi/tagbar.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/tagbar"
fi

REPO_DIR="$HOME/.repositories/gitgutter"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin main
else
    git clone https://github.com/airblade/vim-gitgutter.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/gitgutter"
fi

REPO_DIR="$HOME/.repositories/lightline"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/itchyny/lightline.vim.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/lightline"
fi

REPO_DIR="$HOME/.repositories/gitbranch"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/itchyny/vim-gitbranch "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/gitbranch"
fi

REPO_DIR="$HOME/.repositories/gutentags"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/ludovicchabant/vim-gutentags.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/gutentags"
fi

REPO_DIR="$HOME/.repositories/ale"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/w0rp/ale.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/ale"
fi

REPO_DIR="$HOME/.repositories/lightline-ale"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/maximbaz/lightline-ale.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/lightline-ale"
fi

REPO_DIR="$HOME/.repositories/goyo"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/junegunn/goyo.vim.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/goyo"
fi

REPO_DIR="$HOME/.repositories/limelight"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/junegunn/limelight.vim.git "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/limelight"
fi

REPO_DIR="$HOME/.repositories/undotree"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/mbbill/undotree "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/undotree"
fi

REPO_DIR="$HOME/.repositories/buftabline"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/ap/vim-buftabline "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/buftabline"
fi

REPO_DIR="$HOME/.repositories/grepper"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/mhinz/vim-grepper "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/grepper"
fi

REPO_DIR="$HOME/.repositories/hardtime"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/takac/vim-hardtime "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/hardtime"
fi

REPO_DIR="$HOME/.repositories/yaml-folds"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/pedrohdz/vim-yaml-folds "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/yaml-folds"
fi

REPO_DIR="$HOME/.repositories/list-toggle"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/Valloric/ListToggle "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/list-toggle"
fi

REPO_DIR="$HOME/.repositories/supertab"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/ervandew/supertab "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/supertab"
fi

REPO_DIR="$HOME/.repositories/surround"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/tpope/vim-surround "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/surround"
fi

REPO_DIR="$HOME/.repositories/polyglot"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/sheerun/vim-polyglot "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/polyglot"
fi

REPO_DIR="$HOME/.repositories/nerdcommenter"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/preservim/nerdcommenter "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/nerdcommenter"
fi

REPO_DIR="$HOME/.repositories/fzf"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/junegunn/fzf "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/fzf"
fi

REPO_DIR="$HOME/.repositories/fzf.vim"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/junegunn/fzf.vim "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/fzf.vim"
fi

REPO_DIR="$HOME/.repositories/endwise"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/tpope/vim-endwise "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/endwise"
fi

REPO_DIR="$HOME/.repositories/rails"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/tpope/vim-rails "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/rails"
fi

REPO_DIR="$HOME/.repositories/bundler"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/tpope/vim-bundler "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/bundler"
fi

REPO_DIR="$HOME/.repositories/dispatch"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/tpope/vim-dispatch "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/dispatch"
fi

REPO_DIR="$HOME/.repositories/obsession"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/tpope/vim-obsession "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/obsession"
fi

REPO_DIR="$HOME/.repositories/prosession"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin master
else
    git clone https://github.com/dhruvasagar/vim-prosession "$REPO_DIR"
    ln -sfv "$REPO_DIR" "$HOME/.vim/pack/bundle/start/prosession"
fi
