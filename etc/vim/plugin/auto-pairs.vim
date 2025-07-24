nnoremap <leader>ap :call AutoPairsToggle()<CR>

" Custom pairs for specific file types
augroup autopairs_custom
    autocmd!
    autocmd FileType ruby let b:AutoPairs = AutoPairsDefine({'|':'|'})
    autocmd FileType markdown let b:AutoPairs = AutoPairsDefine({'*':'*', '`':'`'})
    autocmd FileType html,eruby let b:AutoPairs = AutoPairsDefine({'<':'>'})
augroup END
