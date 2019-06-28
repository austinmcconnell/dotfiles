
set nocompatible            " don't worry about compatibility with vi
filetype on                 " try to detect filetype when opening a file
filetype plugin on          " load plugin for related filetype
filetype indent on          " load indent standards for related filetype

" Colors
syntax enable               " enable syntax highlighting
colorscheme darcula         " awesome colorscheme
let python_highlight_all=1  " enable all Python syntax highlighting features


" Editing
set backspace=indent,eol,start  " make backspace behave like normal in insert mode


" Spaces & Tabs
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set autoindent      " indent when moving to next line of code
set smartindent     " indent after if and for statements


" UI Config
set number              " show line numbers
set ruler               " show cursor line and column number
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


" Folding
set foldenable          " enable folding
set foldmethod=indent   " fold based on indent level
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
nnoremap <space> za   " fold via spacebar


" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif   " open NERDTree if no file specified
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__']  " ignore certain files and directories
let NERDTreeShowHidden=1
