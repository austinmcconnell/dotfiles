" Editing
setlocal ts=4 sts=4 sw=4 expandtab

" Enable linters
let b:ale_linters = [
  \ 'bashate',
  \ 'shellcheck',
  \ 'language_server',
  \ ]

" Enable fixers
let b:ale_fixers = [
  \ 'remove_trailing_lines',
  \ 'shfmt',
  \ 'trim_whitespace',
  \ ]

let g:ale_json_jq_options = '--indent 4'

let g:ale_sh_bashate_options = '--max-line-length 100'
