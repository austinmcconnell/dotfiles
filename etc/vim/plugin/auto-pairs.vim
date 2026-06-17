nnoremap <leader>ap :call AutoPairsToggle()<CR>
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutBackInsert = ''
let g:AutoPairsShortcutToggleMultilineClose = ''

" Custom pairs for specific file types
augroup autopairs_custom
    autocmd!
    autocmd FileType ruby let b:AutoPairs = autopairs#AutoPairsDefine({'|':'|'})
    autocmd FileType markdown let b:AutoPairs = autopairs#AutoPairsDefine({'*':'*', '`':'`'})
    autocmd FileType html,eruby let b:AutoPairs = autopairs#AutoPairsDefine({'<':'>'})
augroup END
