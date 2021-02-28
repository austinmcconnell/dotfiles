" General
set nocompatible            " don't worry about compatibility with vi
set encoding=utf8           " set encoding to UTF-8
set updatetime=250
let mapleader = ";"


" Filetypes
filetype on                 " try to detect filetype when opening a file
filetype plugin on          " load plugin for related filetype
filetype indent on          " load indent standards for related filetype

" Colors
augroup my_colours
  autocmd!
  autocmd ColorScheme solarized hi SpellBad ctermfg=206
  autocmd ColorScheme solarized hi SpellCap ctermfg=77
  autocmd ColorScheme solarized hi SpellRare ctermfg=77
  autocmd ColorScheme solarized hi SpellLocal ctermfg=77
augroup END
set background=dark         " set dark mode
colorscheme solarized       " awesome colorscheme

" Editing
set backspace=indent,eol,start                               " make backspace behave like normal in insert mode
set spell                                                    " enable spellchecking
set spelllang=en_us                                          " set spell language to US English
nnoremap <leader>s :set spell!<CR>|                          " toggle spellchecking
set spellfile=$HOME/Dropbox/vim/spell/en.utf-8.add           " set custom dictionary file location
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
syntax enable           " enable syntax highlighting
set laststatus=2        " always show statusline

" Searching
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
set complete-=i                               " don't scan system/language included files
set complete+=kspell                          " match dictionary words

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
autocmd VimResized * wincmd =|  " auto resize splits when window size changes


" Folding
set foldenable          " enable folding
set foldmethod=indent   " fold based on indent level
set foldlevelstart=99   " open all folds by default
nnoremap <space> za|    " fold via spacebar

" Buffers
nnoremap <Leader>b :buffers<CR>:buffer<Space>

" Terminal
tnoremap <Esc> <C-\><C-n>|      " get to terminal normal mode
map <Leader>T :term <cr>|       " vim-powered terminal in split window

" Plugins
" Buftabline
let g:buftabline_numbers=1      "use buffer number as buffer label
let g:buftabline_indicators=1   " indicate whether modified in buffer label


" NERDTree
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__']  " ignore certain files and directories
let NERDTreeShowHidden=1
nnoremap <leader>n :NERDTreeToggle<CR>


" Undotree
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<CR>


" Supertab
"let g:SuperTabDefaultCompletionType = "<c-n>"               " tab down completion list instead of up
"let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"   " force Supertab to always use omni-completion


" Tagbar
set tags+=.git/tags                                            " add custom tags build location to tags search path
nnoremap <leader>t :TagbarToggle<CR>
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
let g:ale_set_balloons=1                      " show help documentation in popups
nnoremap gd :ALEGoToDefinition<CR>
nnoremap <leader>fr :ALEFindReferences<CR>
nnoremap K :ALEHover<CR>
nnoremap <leader>r :ALERename<CR>

" Goyo/Limelight
nnoremap <Leader>gy :Goyo<CR>

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

let g:limelight_conceal_ctermfg = '240'    " set foreground conceal color


" Grepper
nnoremap <leader>f :Grepper -highlight<cr>


" VimWiki
"let wiki_1 = {}
"let wiki_1.path = '~/dropbox/wiki/'
"let wiki_1.syntax = 'markdown'
"let wiki_1.ext = '.md'
"let g:vimwiki_list = [wiki_1]


" GitGutter
highlight! link SignColumn LineNr


" Hardtime
let g:hardtime_default_on = 1
let g:hardtime_showmsg = 1
let g:hardtime_ignore_buffer_patterns = [ "NERD.*", "undotree*", "Tagbar" ]
let g:hardtime_ignore_quickfix = 1

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
