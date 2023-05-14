let g:ale_fix_on_save = 1
let g:ale_open_list=0                         " automatically open location list when issues found
let g:ale_lint_on_text_changed='always'       " run linter when text changed in insert or normal mode
let g:ale_completion_enabled = 1              " turn on ale completion
let g:ale_set_balloons=1                      " show help documentation in popups
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'

nnoremap gd :ALEGoToDefinition<CR>
nnoremap gr :ALEFindReferences<CR>
nnoremap gR :ALERename<CR>
nnoremap <silent> K :call <SID>show_documentation()<CR>

nmap [w <Plug>(ale_previous)
nmap ]w <Plug>(ale_next)
nmap [W <Plug>(ale_first)
nmap ]W <Plug>(ale_last)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call ale#hover#ShowAtCursor()
  endif
endfunction


" Enable linters
let g:ale_linters = {
\   'dockerfile': ['hadolint'],
\   'json': ['jq', 'jsonlint', 'spectral'],
\   'markdown': ['markdownlint', 'proselint', 'writegood'],
\   'python': ['pylint', 'pyright'],
\   'sh': ['bashate', 'shellcheck', 'language_server'],
\   'terraform': ['terraform'],
\   'yaml': ['spectral', 'yamllint'],
\   'zsh': ['bashate', 'shellcheck', 'language_server'],
\}

" Enable fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'json': ['jq'],
\   'markdown': ['prettier'],
\   'python': ['isort', 'yapf'],
\   'sh': ['shfmt'],
\   'terraform': ['terraform'],
\   'yaml': ['prettier','yamlfix'],
\   'zsh': ['shfmt'],
\}


let g:ale_javascript_prettier_options = '--config ~/.config/prettier.toml'

let g:ale_json_jq_options = '--indent 4'

let g:ale_python_auto_pipenv=1

let g:ale_python_isort_options = '--settings-path ~/.config/isort/.isort.cfg'

let g:ale_python_mypy_auto_pipenv = 1
let g:ale_python_mypy_ignore_invalid_syntax = 1

let g:ale_sh_bashate_options = '--max-line-length 100 --ignore E006,E040'
let g:ale_sh_shfmt_options = '--indent 4'
