" Modern Vim Configuration
" Philosophy: Git-centric, auto-saving, comprehensive tooling
" Optimized for: Cross-platform development environments

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

call plug#begin('~/.vim/pack/plugins/start/')

" colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'blueshirts/darcula'
Plug 'rose-pine/vim', { 'as': 'rose-pine' }
Plug 'sainnhe/everforest'
Plug 'nordtheme/vim', { 'as':'nord' }
Plug 'nordtheme/dircolors'

" searching
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'

" git
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/vim-gitbranch'

" status
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'

" editing/ui
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
Plug 'mbbill/undotree'
" Plug 'ap/vim-buftabline'
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['sensible']
" https://github.com/junegunn/vim-plug/issues/1141#issuecomment-2024328900

Plug 'pedrohdz/vim-yaml-folds'
Plug 'w0rp/ale'
Plug 'vim-scripts/autocomplpop'
Plug 'tpope/vim-surround'
Plug 'Valloric/ListToggle'

" tags
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

" directory tree
" Plug 'preservim/nerdtree'
" Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern-mapping-mark-children.vim'
Plug 'lambdalisue/fern-git-status.vim'

" ruby development
Plug 'tpope/vim-bundler', { 'for': 'ruby' }
Plug 'tpope/vim-endwise', { 'for': ['ruby', 'sh', 'zsh', 'vim'] }
Plug 'tpope/vim-dispatch', { 'for': 'ruby' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }

" session management
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

" writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

call plug#end()


" General
set nocompatible            " don't worry about compatibility with vi
set encoding=utf8           " set encoding to UTF-8
set updatetime=100
let mapleader = ";"
set ttimeoutlen=100         " time to wait for a key code or mapped key sequence to complete
set nrformats -=octal       " don't treat numbers with leading zeros as octal numbers


" Filetypes
filetype on                 " try to detect filetype when opening a file
filetype plugin on          " load plugin for related filetype
filetype indent on          " load indent standards for related filetype

" Colors
augroup solarized-overrides
  autocmd!
  autocmd ColorScheme solarized hi SpellBad ctermfg=206
  autocmd ColorScheme solarized hi SpellCap ctermfg=77
  autocmd ColorScheme solarized hi SpellRare ctermfg=77
  autocmd ColorScheme solarized hi SpellLocal ctermfg=77
augroup END
augroup nord-overrides
  autocmd!
  autocmd ColorScheme nord highlight Folded ctermbg=DarkGrey ctermfg=white
augroup END
set background=dark         " set dark mode
colorscheme nord
set termguicolors

" Editing
set backspace=indent,eol,start                               " make backspace behave like normal in insert mode
nnoremap j gj|                                               " move cursor visually down one line even when text is wrapped
nnoremap k gk|                                               " move cursor visually up one line even when text is wrapped
vnoremap . :norm.<CR>|                                       " use period to execute a stored action in visual mode
set scrolloff=1                                              " show at least one line below cursor
set list                                                     " display whitespace
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+    " set whitespace characters to highlight
set autoread                                                 " auto load external changes to file
set autowriteall                                             " automatically write to file
set undofile                                                 " Maintain undo history between sessions
set undodir=~/.vim/undodir                                   " Store all undo history files in a single directory
set nowritebackup                                            " Don't create backup before overwriting (default: on)
set noswapfile                                               " Disable swap files (rely on auto-save and git)

" Spelling
"set spell                                                   " enable spellchecking
set spelllang=en_us                                          " set spell language to US English
nnoremap <leader>s :set spell!<CR>|                          " toggle spellchecking
set spellfile=$DOTFILES_DIR/etc/vim/spell/en.utf-8.add                " set custom dictionary file location

for d in glob('$DOTFILES_DIR/etc/vim/spell/*.add', 1, 1)
    if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
        exec 'mkspell! ' . fnameescape(d)
    endif
endfor

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
set signcolumn=yes      " always show sign column (prevents text jumping)
set mouse=a             " enable mouse support
syntax enable           " enable syntax highlighting
set laststatus=2        " always show statusline
set title               " let vim set title of terminal window
set titlestring+=%{substitute(getcwd(),\ $HOME,\ '~',\ '')}


" Cursor
let &t_SI = "\e[6 q"                " steady bar cursor in insert mode
let &t_EI = "\e[2 q"                " steady block in other modes


" Searching
" nnoremap <leader>f :find<Space>
set incsearch                        " search as characters are entered
set ignorecase                       " perform case-insensitive searches
set hlsearch                         " highlight matches
set path+=**                         " search down into subfolders
set wildmenu                         " display all matching files when I tab complete
set wildignore+=*.pyc                " ignore python cache files  when searching
set wildignore+=*/__pycache__/*      " ignore __pycache__ directory when searching
set wildignore+=*/.venv/*            " ignore .venv directory when searching
set wildignore+=*/venv/*             " ignore venv directory when searching
set wildignore+=*/build/*            " ignore build directory when searching
set wildignore+=*/dist/*             " ignore dist directory when searching
set wildignore+=*/node_modules/*     " ignore node_modules directory when searching

" Completion
set completeopt=menuone,longest,preview
set complete-=i                               " don't scan system/language included files
set complete+=kspell                          " match dictionary words
inoremap <C-]> <C-X><C-]>
inoremap <C-F> <C-X><C-F>
inoremap <C-D> <C-X><C-D>
inoremap <C-L> <C-X><C-L>
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

" Splits
set splitbelow                  " open new split below
set splitright                  " open new split to the right
autocmd VimResized * wincmd =|  " auto resize splits when window size changes
nnoremap <C-J> <C-W><C-J>|      " jump to split below current
nnoremap <C-K> <C-W><C-K>|      " jump to split above current
nnoremap <C-L> <C-W><C-L>|      " jump to split to the right of current
nnoremap <C-H> <C-W><C-H>|      " jump to split to the left of current

" Disabling terminal mappings because they prevent C-J, C-K navigation in fzf
" window
" tnoremap <C-J> <C-W><C-J>|      " jump to split below current
" tnoremap <C-K> <C-W><C-K>|      " jump to split above current
" tnoremap <C-L> <C-W><C-L>|      " jump to split to the right of current
" tnoremap <C-H> <C-W><C-H>|      " jump to split to the left of current


" Folding
set foldenable          " enable folding
set foldmethod=indent   " fold based on indent level
set foldlevelstart=99   " open all folds by default
nnoremap <space> za|    " fold via spacebar

" Buffers
" nnoremap <Leader>b :buffers<CR>:buffer<Space>

" Terminal
tnoremap <Esc> <C-\><C-n>|      " get to terminal normal mode
map <leader>T :term <cr>|       " vim-powered terminal in split window

set tags+=.git/tags                                            " add custom tags build location to tags search path
