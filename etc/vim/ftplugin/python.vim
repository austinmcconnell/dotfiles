set colorcolumn=101               "highlight column showing longer than 100 chars
let python_highlight_all=1        " enable all Python syntax highlighting features

" Enable Python linters
let b:ale_linters = [
  \ 'flake8',
  \ 'mypy',
  \ 'pylint',
  \ 'pylsp',
  \ ]

" Enable Python fixers
let b:ale_fixers = [
  \ 'isort',
  \ 'remove_trailing_lines',
  \ 'trim_whitespace',
  \ ]

let g:ale_python_auto_pipenv=1

let g:ale_python_isort_options = '--settings-path ~/.config/isort/.isort.cfg'

let g:ale_python_mypy_auto_pipenv = 1
let g:ale_python_mypy_ignore_invalid_syntax = 1
