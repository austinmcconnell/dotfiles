
set nocompatible            " don't worry about compatibility with vi

" Colors
syntax enable               " enable syntax highlighting
colorscheme darcula         " awesome colorscheme


" Spaces & Tabs
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set autoindent      " indent when moving to next line of code
set smartindent     " indent after if and for statements

" UI Config
set number              " show line numbers
set showmatch           " highlight matching [{()}]

" Searching
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set path+=**            " search down into subfolders
set wildmenu            " display all matching files when I tab complete
set wildignore=*.pyc    " ignore these when searching

" Split Navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
 
