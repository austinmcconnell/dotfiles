
" Editing
setlocal ts=4 sts=4 sw=4 expandtab

" Spelling
set nospell

" Enable JSON linters
let b:ale_linters = [
  \ 'jq',
  \ 'jsonlint',
  \ 'spectral',
  \ ]

" Enable JSON fixers
let b:ale_fixers = [
  \ 'jq',
  \ 'remove_trailing_lines',
  \ 'trim_whitespace',
  \ ]

let g:ale_json_jq_options = '--indent 4'
