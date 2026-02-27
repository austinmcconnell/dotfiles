" Ditto Configuration
" Plugin: https://github.com/dbmrq/vim-ditto

" Minimum word length to highlight
let g:ditto_min_word_length = 4

" Minimum repetitions to trigger highlighting
let g:ditto_min_repetitions = 3

" Scope for DittoOn (sentence, paragraph, or file)
let g:ditto_mode = 'paragraph'

" Auto-enable in writing directories (uses g:prose_writing_dirs from ale.vim)
augroup ditto_prose
  autocmd!
  execute 'autocmd BufRead,BufNewFile ' . g:prose_writing_dirs . ' DittoOn'
augroup END
