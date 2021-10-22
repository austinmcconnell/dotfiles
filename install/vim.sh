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
if [ -d "$HOME/.vim/colors/darcula/.git" ]; then
    git --work-tree="$HOME/.vim/colors/darcula" --git-dir="$HOME/.vim/colors/darcula/.git" pull origin master
else
    git clone https://github.com/blueshirts/darcula "$HOME/.vim/colors/darcula/"
    ln -sfv "$HOME/.vim/colors/darcula/colors/darcula.vim" "$HOME/.vim/colors/darcula.vim"
fi

if [ -d "$HOME/.vim/colors/solarized/.git" ]; then
    git --work-tree="$HOME/.vim/colors/solarized" --git-dir="$HOME/.vim/colors/solarized/.git" pull origin master
else
    git clone https://github.com/altercation/vim-colors-solarized "$HOME/.vim/colors/solarized/"
    ln -sfv "$HOME/.vim/colors/solarized/colors/solarized.vim" "$HOME/.vim/colors/solarized.vim"
fi

if [ -d "$HOME/.vim/colors/nord/.git" ]; then
    git --work-tree="$HOME/.vim/colors/nord" --git-dir="$HOME/.vim/colors/nord/.git" pull origin develop
else
    git clone https://github.com/arcticicestudio/nord-vim "$HOME/.vim/colors/nord/"
    ln -sfv "$HOME/.vim/colors/nord/colors/nord.vim" "$HOME/.vim/colors/nord.vim"
fi

## Add plugins
if [ -d "$HOME/.vim/pack/bundle/start/auto-pairs/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/auto-pairs" --git-dir="$HOME/.vim/pack/bundle/start/auto-pairs/.git" pull origin master
else
    git clone https://github.com/jiangmiao/auto-pairs.git "$HOME/.vim/pack/bundle/start/auto-pairs"
fi

if [ -d "$HOME/.vim/pack/bundle/start/nerdtree/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/nerdtree" --git-dir="$HOME/.vim/pack/bundle/start/nerdtree/.git" pull origin master
else
    git clone https://github.com/preservim/nerdtree.git "$HOME/.vim/pack/bundle/start/nerdtree"
fi

if [ -d "$HOME/.vim/pack/bundle/start/nerdtree-git/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/nerdtree-git" --git-dir="$HOME/.vim/pack/bundle/start/nerdtree-git/.git" pull origin master
else
    git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git "$HOME/.vim/pack/bundle/start/nerdtree-git"
fi

if [ -d "$HOME/.vim/pack/bundle/start/tagbar/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/tagbar" --git-dir="$HOME/.vim/pack/bundle/start/tagbar/.git" pull origin master
else
    git clone https://github.com/majutsushi/tagbar.git "$HOME/.vim/pack/bundle/start/tagbar"
fi

if [ -d "$HOME/.vim/pack/bundle/start/gitgutter/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/gitgutter" --git-dir="$HOME/.vim/pack/bundle/start/gitgutter/.git" pull origin master
else
    git clone https://github.com/airblade/vim-gitgutter.git "$HOME/.vim/pack/bundle/start/gitgutter"
fi

if [ -d "$HOME/.vim/pack/bundle/start/lightline/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/lightline" --git-dir="$HOME/.vim/pack/bundle/start/lightline/.git" pull origin master
else
    git clone https://github.com/itchyny/lightline.vim.git "$HOME/.vim/pack/bundle/start/lightline"
fi

if [ -d "$HOME/.vim/pack/bundle/start/fugitive/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/fugitive" --git-dir="$HOME/.vim/pack/bundle/start/fugitive/.git" pull origin master
else
    git clone https://github.com/tpope/vim-fugitive.git "$HOME/.vim/pack/bundle/start/fugitive"
fi

if [ -d "$HOME/.vim/pack/bundle/start/gutentags/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/gutentags" --git-dir="$HOME/.vim/pack/bundle/start/gutentags/.git" pull origin master
else
    git clone https://github.com/ludovicchabant/vim-gutentags.git "$HOME/.vim/pack/bundle/start/gutentags"
fi

if [ -d "$HOME/.vim/pack/bundle/start/ale/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/ale" --git-dir="$HOME/.vim/pack/bundle/start/ale/.git" pull origin master
else
    git clone https://github.com/w0rp/ale.git "$HOME/.vim/pack/bundle/start/ale"
fi

if [ -d "$HOME/.vim/pack/bundle/start/lightline-ale/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/lightline-ale" --git-dir="$HOME/.vim/pack/bundle/start/lightline-ale/.git" pull origin master
else
    git clone https://github.com/maximbaz/lightline-ale.git "$HOME/.vim/pack/bundle/start/lightline-ale"
fi

if [ -d "$HOME/.vim/pack/bundle/start/goyo/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/goyo" --git-dir="$HOME/.vim/pack/bundle/start/goyo/.git" pull origin master
else
    git clone https://github.com/junegunn/goyo.vim.git "$HOME/.vim/pack/bundle/start/goyo"
fi

if [ -d "$HOME/.vim/pack/bundle/start/limelight/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/limelight" --git-dir="$HOME/.vim/pack/bundle/start/limelight/.git" pull origin master
else
    git clone https://github.com/junegunn/limelight.vim.git "$HOME/.vim/pack/bundle/start/limelight"
fi

if [ -d "$HOME/.vim/pack/bundle/start/undotree/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/undotree" --git-dir="$HOME/.vim/pack/bundle/start/undotree/.git" pull origin master
else
    git clone https://github.com/mbbill/undotree "$HOME/.vim/pack/bundle/start/undotree"
fi

if [ -d "$HOME/.vim/pack/bundle/start/buftabline/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/buftabline" --git-dir="$HOME/.vim/pack/bundle/start/buftabline/.git" pull origin master
else
    git clone https://github.com/ap/vim-buftabline "$HOME/.vim/pack/bundle/start/buftabline"
fi

if [ -d "$HOME/.vim/pack/bundle/start/grepper/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/grepper" --git-dir="$HOME/.vim/pack/bundle/start/grepper/.git" pull origin master
else
    git clone https://github.com/mhinz/vim-grepper "$HOME/.vim/pack/bundle/start/grepper"
fi

if [ -d "$HOME/.vim/pack/bundle/start/hardtime/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/hardtime" --git-dir="$HOME/.vim/pack/bundle/start/hardtime/.git" pull origin master
else
    git clone https://github.com/takac/vim-hardtime "$HOME/.vim/pack/bundle/start/hardtime"
fi

if [ -d "$HOME/.vim/pack/bundle/start/indentline/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/indentline" --git-dir="$HOME/.vim/pack/bundle/start/indentline/.git" pull origin master
else
    git clone https://github.com/Yggdroot/indentLine "$HOME/.vim/pack/bundle/start/indentline"
fi

if [ -d "$HOME/.vim/pack/bundle/start/yaml-folds/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/yaml-folds" --git-dir="$HOME/.vim/pack/bundle/start/yaml-folds/.git" pull origin master
else
    git clone https://github.com/pedrohdz/vim-yaml-folds "$HOME/.vim/pack/bundle/start/yaml-folds"
fi

if [ -d "$HOME/.vim/pack/bundle/start/list-toggle/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/list-toggle" --git-dir="$HOME/.vim/pack/bundle/start/list-toggle/.git" pull origin master
else
    git clone https://github.com/Valloric/ListToggle "$HOME/.vim/pack/bundle/start/list-toggle"
fi

if [ -d "$HOME/.vim/pack/bundle/start/supertab/.git" ]; then
    git --work-tree="$HOME/.vim/pack/bundle/start/supertab" --git-dir="$HOME/.vim/pack/bundle/start/supertab/.git" pull origin master
else
    git clone https://github.com/ervandew/supertab "$HOME/.vim/pack/bundle/start/supertab"
fi
