set colorcolumn=101

" Enable Python linters
let b:ale_linters = [
  \ 'flake8',
  \ 'mypy',
  \ 'pylint',
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
