
" Editing
setlocal ts=2 sts=2 sw=2 expandtab

" Spelling
set nospell

" indentLine plugin
let g:indentLine_enabled = 1
let g:indentLine_char = '⦙'

" Enable linters
let b:ale_linters = [
  \ 'spectral',
  \ 'yamllint',
  \ ]

" Enable fixers
let b:ale_fixers = [
  \ 'remove_trailing_lines',
  \ 'trim_whitespace',
  \ 'yamlfix'
  \ ]
