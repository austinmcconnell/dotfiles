nnoremap <leader>t :TagbarToggle<CR>
autocmd FileType python  nested :call tagbar#autoopen(0)       " show Tagbar when opening python files
