" Core ALE Settings
let g:ale_fix_on_save = 1                     " automatically fix issues on save
let g:ale_open_list=0                         " automatically open location list when issues found
let g:ale_lint_on_text_changed='always'      " run linter when text changed in insert or normal mode
let g:ale_set_balloons=1                      " show help documentation in popups
let g:ale_sign_error = '✘'                   " error sign in gutter
let g:ale_sign_warning = '⚠'                 " warning sign in gutter

" Completion Settings
let g:ale_completion_enabled = 1              " enable ale completion
let g:ale_completion_autoimport = 1           " enable auto-import suggestions
let g:ale_completion_delay = 500              " delay before showing completion (ms)
let g:ale_completion_max_suggestions = 50     " maximum number of completion suggestions

" Debug Settings (for troubleshooting performance issues)
let g:ale_history_enabled = 1                 " enable command history tracking (minimal overhead)
let g:ale_history_log_output = 0              " log linter output for debugging (set to 1 when needed)

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

" function! RemapAleCompletion()
"   iunmap <Plug>(ale_show_completion_menu)
"   inoremap <silent> <Plug>(ale_show_completion_menu) <C-x><C-o>
" endfunction
"
" augroup remap_ale_completion
"   autocmd!
"   autocmd VimEnter * call RemapAleCompletion()
" augroup END

" Enable linters
let g:ale_linters = {
\   'dockerfile': ['hadolint'],
\   'json': ['jq', 'jsonlint', 'spectral'],
\   'markdown': ['markdownlint'],
\   'python': ['pylint'],
\   'ruby': ['rubocop'],
\   'sh': ['bashate', 'shellcheck', 'language_server'],
\   'terraform': ['terraform'],
\   'yaml': ['spectral', 'yamllint'],
\   'zsh': ['bashate', 'shellcheck', 'language_server'],
\}
", 'mypy' disable python mypy linter. When I am braver, try this again
" , 'proselint', 'writegood' disable markdown prose linters. Optionally enable when I am writing prose

" Enable fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'json': ['jq'],
\   'markdown': ['prettier'],
\   'python': ['isort', 'yapf', 'autoflake'],
\   'ruby': ['rubocop'],
\   'sh': ['shfmt'],
\   'terraform': ['terraform'],
\   'yaml': ['prettier','yamlfix'],
\   'zsh': ['shfmt'],
\}


let g:ale_javascript_prettier_options = '--config ~/.config/prettier.toml'

let g:ale_json_jq_options = '--indent 4'

let g:ale_python_auto_pipenv=1

let g:ale_python_isort_options = '--settings-path ~/.config/isort/config'

" Python autoflake options for removing unused imports
let g:ale_python_autoflake_options = '--remove-all-unused-imports --remove-unused-variables'

" Python mypy options
let g:ale_python_mypy_auto_pipenv = 1
let g:ale_python_mypy_ignore_invalid_syntax = 1

let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_ruby_rubocop_options = '--config ~/.config/rubocop/config.yml'

let g:ale_sh_bashate_options = '--max-line-length 100 --ignore E006,E040'
let g:ale_sh_shfmt_options = '--indent 4'
