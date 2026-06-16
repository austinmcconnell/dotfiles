let g:tagbar_singleclick = 1
nnoremap <leader>t :TagbarToggle<CR>
autocmd FileType python :call tagbar#autoopen(0)       " show Tagbar when opening python files
