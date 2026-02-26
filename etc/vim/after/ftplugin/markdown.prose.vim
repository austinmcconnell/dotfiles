" Enable prose linters for markdown.prose filetype
"
" Usage: Add this line to the top of any prose file:
"   <!-- vim: set ft=markdown.prose: -->

let g:ale_linters = get(g:, 'ale_linters', {})
let g:ale_linters['markdown.prose'] = ['markdownlint', 'proselint', 'writegood']
