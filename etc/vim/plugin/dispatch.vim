nnoremap <leader>dd :Dispatch<Space>
nnoremap <leader>d! :Dispatch!<Space>
nnoremap <leader>dm :Make<CR>
nnoremap <leader>dc :Copen<CR>

" Language-specific dispatch configurations
augroup dispatch_settings
    autocmd!
    autocmd FileType ruby let b:dispatch = 'ruby %'
    autocmd BufRead,BufNewFile *_spec.rb let b:dispatch = 'rspec %'
    autocmd FileType python let b:dispatch = 'python %'
    autocmd BufRead,BufNewFile test_*.py let b:dispatch = 'python -m pytest %'
augroup END
