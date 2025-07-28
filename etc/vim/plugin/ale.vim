" Core ALE Settings
let g:ale_fix_on_save = 1                     " automatically fix issues on save
let g:ale_open_list = 0                       " don't auto-open location list
let g:ale_lint_on_text_changed='always'       " run linter when text changed in insert or normal mode
let g:ale_lint_delay=200                      " wait time in ms after stopping typing before linting
let g:ale_lint_on_enter = 1                   " lint when entering buffer
let g:ale_set_balloons = 1                    " show help documentation in popups
let g:ale_sign_error = '✘'                    " error sign in gutter
let g:ale_sign_warning = '⚠'                  " warning sign in gutter

" Completion Settings
let g:ale_completion_enabled = 1              " disable ale completion (use native vim completion)
let g:ale_completion_autoimport = 1           " enable auto-import suggestions
let g:ale_completion_delay = 200              " delay before showing completion (ms)
let g:ale_completion_max_suggestions = 25     " maximum number of completion suggestions

" Performance Settings
let g:ale_history_enabled = 1                 " enable command history tracking
let g:ale_history_log_output = 0              " disable logging for performance
let g:ale_maximum_file_size = 500000          " don't lint huge files
let g:ale_cache_executable_check_failures = 1 " cache missing executables

let g:ale_linters = {
\   'dockerfile': ['hadolint'],
\   'go': ['gopls', 'gofmt'],
\   'json': ['jq', 'jsonlint', 'spectral'],
\   'markdown': ['markdownlint'],
\   'python': ['ruff'],
\   'ruby': ['rubocop', 'ruby_lsp'],
\   'sh': ['bashate', 'shellcheck', 'language_server'],
\   'terraform': ['terraform'],
\   'yaml': ['spectral', 'yamllint'],
\   'zsh': ['bashate', 'shellcheck', 'language_server'],
\}
", 'mypy' disable python mypy linter. When I am braver, try this again
" , 'proselint', 'writegood' disable markdown prose linters. Optionally enable when I am writing prose

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'go': ['gofmt', 'goimports'],
\   'json': ['jq', 'prettier'],
\   'markdown': ['prettier'],
\   'python': ['ruff', 'yapf', 'autoflake'],
\   'ruby': ['rubocop'],
\   'sh': ['shfmt'],
\   'terraform': ['terraform'],
\   'yaml': ['prettier'],
\   'zsh': ['shfmt'],
\}

" Python-specific settings (optimized for pylsp)
let g:ale_python_pylsp_config = {
\   'pylsp': {
\     'plugins': {
\       'pycodestyle': {
\         'enabled': v:true,
\         'maxLineLength': 100
\       },
\       'mccabe': {'enabled': v:false},
\       'pyflakes': {'enabled': v:true},
\       'pylint': {'enabled': v:false},
\     }
\   }
\}


let g:ale_javascript_prettier_options = '--config ~/.config/prettier.toml'

let g:ale_json_jq_options = '--indent 4'

let g:ale_python_auto_pipenv=1

" Go-specific settings
let g:ale_go_gofmt_options = '-s'  " Simplify code
let g:ale_go_goimports_options = '-local'  " Group local imports

" Python yapf options for formatting
let g:ale_python_yapf_options = '--style ~/.config/yapf/style'

" Python autoflake options for removing unused imports
let g:ale_python_autoflake_options = '--remove-all-unused-imports --remove-unused-variables'

" Python mypy options
let g:ale_python_mypy_auto_pipenv = 1
let g:ale_python_mypy_ignore_invalid_syntax = 1

let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_ruby_rubocop_options = '--config ~/.config/rubocop/config.yml'

let g:ale_sh_bashate_options = '--max-line-length 100 --ignore E006,E040'
let g:ale_sh_shfmt_options = '--indent 4'

" YAML yamllint options
let g:ale_yaml_yamllint_options = '-c ~/.config/yamllint/config'

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
