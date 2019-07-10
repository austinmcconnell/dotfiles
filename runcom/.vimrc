
set nocompatible            " don't worry about compatibility with vi
set encoding=utf8           " set encoding to UTF-8
set updatetime=250

" Filetypes
filetype on                 " try to detect filetype when opening a file
filetype plugin on          " load plugin for related filetype
filetype indent on          " load indent standards for related filetype


" Colors
syntax enable               " enable syntax highlighting
"set termguicolors           " enable true colors (24 bit)
set background=dark         " set dark mode
colorscheme solarized       " awesome colorscheme
let python_highlight_all=1  " enable all Python syntax highlighting features


" Editing
set backspace=indent,eol,start             " make backspace behave like normal in insert mode
set spell                                  " enable spellchecking
set spellfile=~/.vim/spell/en.utf-8.add    " set custom dictionary file location
nnoremap j gj|                             " move cursor visually down one line even when text is wrapped
nnoremap k gk|                             " move cursor visually up one line even when text is wrapped


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
set laststatus=2        " always show statusline


" Searching
set incsearch                        " search as characters are entered
set hlsearch                         " highlight matches
set path+=**                         " search down into subfolders
set wildmenu                         " display all matching files when I tab complete
set wildignore+=*.pyc                " ignore python cache files  when searching
set wildignore+=**/.venv/**          " ignore .venv directory when searching
set wildignore+=**/node_modules/**   " ignore node_modules directory when searching


" Split Navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" Folding
set foldenable          " enable folding
set foldmethod=indent   " fold based on indent level
set foldlevelstart=99   " open all folds by default
nnoremap <space> za   " fold via spacebar


" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif    " open NERDTree when opening a directory
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__']  " ignore certain files and directories
let NERDTreeShowHidden=1


" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"               " tab down completion list instead of up
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"   " force Supertab to always use omni-completion


" Tagbar
set tags+=.git/tags                                     " add custom tags build location to tags search path
nnoremap <leader>t :TagbarToggle<CR>
autocmd FileType python  nested :call tagbar#autoopen(0)       " show Tagbar when opening python files

" Gutentags
let g:gutentags_ctags_tagfile='.git/tags'

" Lightline
set noshowmode
let g:lightline = {}
let g:lightline.colorscheme='solarized'

let g:lightline.component_function = {
    \  'gitbranch': 'fugitive#head',
    \ }

let g:lightline.component_expand = {
    \  'linter_checking': 'lightline#ale#checking',
    \  'linter_warnings': 'lightline#ale#warnings',
    \  'linter_errors': 'lightline#ale#errors',
    \  'linter_ok': 'lightline#ale#ok',
    \ }

let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }

let g:lightline.active = {
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'fileformat', 'fileencoding', 'filetype' ],
    \            [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ] ]
    \ }


" Ale
let g:ale_fix_on_save = 1
let g:ale_open_list=1
let g:ale_lint_on_text_changed='always'


" Goyo/Limelight
nnoremap <Leader>gy :Goyo<CR>

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

let g:limelight_conceal_ctermfg = '240'

