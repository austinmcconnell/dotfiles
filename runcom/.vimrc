set nocompatible            " don't worry about compatibility with vi
set encoding=utf8           " set encoding to UTF-8
set updatetime=250
let mapleader = ";"


" Filetypes
filetype on                 " try to detect filetype when opening a file
filetype plugin on          " load plugin for related filetype
filetype indent on          " load indent standards for related filetype


" Colors
syntax enable               " enable syntax highlighting
set background=dark         " set dark mode
colorscheme solarized       " awesome colorscheme
let python_highlight_all=1  " enable all Python syntax highlighting features


" Editing
set backspace=indent,eol,start                               " make backspace behave like normal in insert mode
set spell                                                    " enable spellchecking
nnoremap <leader>s :set spell!<CR>|                          " toggle spellchecking
set spellfile=~/.vim/spell/en.utf-8.add                      " set custom dictionary file location
hi SpellBad ctermfg=206
nnoremap j gj|                                               " move cursor visually down one line even when text is wrapped
nnoremap k gk|                                               " move cursor visually up one line even when text is wrapped
set scrolloff=1                                              " show at least one line below cursor
set list                                                     " display whitespace
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+    " set whitespace characters to highlight
set autoread                                                 " auto load external changes to file
set undofile                                                 " Maintain undo history between sessions
set undodir=~/.vim/undodir                                   " Store all undo history files in a single directory

let g:auto_save         = 1
let g:auto_save_silent  = 1
let g:auto_save_events  = ["InsertLeave", "TextChanged", "FocusLost"]

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
set showtabline=2       " always show tabline


" Searching
set incsearch                        " search as characters are entered
set ignorecase                       " perform case-insensitive searches
set hlsearch                         " highlight matches
set path+=**                         " search down into subfolders
set wildmenu                         " display all matching files when I tab complete
set wildignore+=*.pyc                " ignore python cache files  when searching
set wildignore+=**/.venv/**          " ignore .venv directory when searching
set wildignore+=**/node_modules/**   " ignore node_modules directory when searching


" Splits
set splitbelow                  " open new split below
set splitright                  " open new split to the right
nnoremap <C-J> <C-W><C-J>|      " jump to split below current
nnoremap <C-K> <C-W><C-K>|      " jump to split above current
nnoremap <C-L> <C-W><C-L>|      " jump to split to the right of current
nnoremap <C-H> <C-W><C-H>|      " jump to split to the left of current
tnoremap <C-J> <C-W><C-J>|      " jump to split below current
tnoremap <C-K> <C-W><C-K>|      " jump to split above current
tnoremap <C-L> <C-W><C-L>|      " jump to split to the right of current
tnoremap <C-H> <C-W><C-H>|      " jump to split to the left of current


" Folding
set foldenable          " enable folding
set foldmethod=indent   " fold based on indent level
set foldlevelstart=99   " open all folds by default
nnoremap <space> za|    " fold via spacebar


" Terminal
tnoremap <Esc> <C-\><C-n>|      " get to terminal normal mode
map <Leader>t :term <cr>|       " vim-powered terminal in split window


" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif    " open NERDTree when opening a directory
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__']  " ignore certain files and directories
let NERDTreeShowHidden=1
nnoremap <leader>n :NERDTreeMirror<CR>:NERDTreeToggle<CR>
"autocmd BufWinEnter * silent NERDTreeMirror                " Open the existing NERDTree on each new tab



" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"               " tab down completion list instead of up
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"   " force Supertab to always use omni-completion


" Tagbar
set tags+=.git/tags                                            " add custom tags build location to tags search path
nnoremap <leader>T :TagbarToggle<CR>
autocmd FileType python  nested :call tagbar#autoopen(0)       " show Tagbar when opening python files


" Gutentags
let g:gutentags_ctags_tagfile='.git/tags'    " set tagfile location


" Lightline
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'component_function': {
    \     'gitbranch': 'fugitive#head',
    \     'gitrelativedir': 'LightlineFilename',
    \ },
    \ 'component_expand': {
    \     'linter_checking': 'lightline#ale#checking',
    \     'linter_warnings': 'lightline#ale#warnings',
    \     'linter_errors': 'lightline#ale#errors',
    \     'linter_ok': 'lightline#ale#ok'
    \ },
    \ 'component_type': {
    \     'linter_checking': 'left',
    \     'linter_warnings': 'warning',
    \     'linter_errors': 'error',
    \     'linter_ok': 'left'
    \ },
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \               [ 'gitbranch', 'readonly', 'gitrelativedir', 'modified' ] ],
    \     'right': [ [ 'lineinfo' ],
    \                [ 'percent' ],
    \                [ 'fileformat', 'fileencoding', 'filetype' ],
    \                [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ] ]
    \ },
    \}

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p:h')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return ''
endfunction


" Ale
let g:ale_fix_on_save = 1
let g:ale_open_list=0                         " automatically open location list when issues found
let g:ale_lint_on_text_changed='always'       " run linter when text changed in insert or normal mode
let g:ale_completion_enabled = 1              " turn on ale completion
set omnifunc=ale#completion#OmniFunc          " use ale for insert auto-completion
set complete-=i                               " don't scan system/language included files
set complete+=kspell                          " match dictionary words

" Goyo/Limelight
nnoremap <Leader>gy :Goyo<CR>

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

let g:limelight_conceal_ctermfg = '240'    " set foreground conceal color


" Ack
let g:ackprg = 'ag --nogroup --nocolor --column'        " tell ack to use ag for searching
let g:ackhighlight = 1                                  " highlight search in files
nnoremap <Leader>f :Ack!<SPACE>
set shellpipe=>                                         " prevent ack results from echoing to terminal


" VimWiki
let wiki_1 = {}
let wiki_1.path = '~/dropbox/wiki/'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'
let g:vimwiki_list = [wiki_1]


" Markdown
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" Auto quit Vim when actual files are closed
function! CheckLeftBuffers()
  if tabpagenr('$') == 1
    let i = 1
    while i <= winnr('$')
      if getbufvar(winbufnr(i), '&buftype') == 'help' ||
            \ getbufvar(winbufnr(i), '&buftype') == 'quickfix' ||
            \ exists('t:NERDTreeBufName') &&
            \   bufname(winbufnr(i)) == t:NERDTreeBufName ||
            \ bufname(winbufnr(i)) == '__Tag_List__'
        let i += 1
      else
        break
      endif
    endwhile
    if i == winnr('$') + 1
      qall
    endif
    unlet i
  endif
endfunction
autocmd BufEnter * call CheckLeftBuffers()
