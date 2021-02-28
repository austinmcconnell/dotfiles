set colorcolumn=101               "highlight column showing longer than 100 chars
let python_highlight_all=1        " enable all Python syntax highlighting features

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

" Enable Python linters
let b:ale_linters = [
  \ 'flake8',
  \ 'mypy',
  \ 'pylint',
  \ 'pyls',
  \ ]

" Enable Python fixers
let b:ale_fixers = [
  \ 'autopep8',
  \ 'isort',
  \ 'remove_trailing_lines',
  \ 'trim_whitespace',
  \ ]

let g:ale_python_auto_pipenv=1

let g:ale_python_isort_options = '--settings-path ~/.config/isort/.isort.cfg'
