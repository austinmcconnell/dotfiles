nnoremap <Right> :n<CR>
nnoremap <Left> :N<CR>

let &fillchars = 'eob: '     " replace end-of-buffer fill character (default: ~) with a blank space

autocmd! User GoyoEnter      " remove autocmd to load limelight on GoyoEnter
autocmd! User GoyoLeave      " remove autocmd to unload limelight on GoyoLeave

"This is not working. Behaves really weirdly. Why?
" if !exists('#goyo')
"     Goyo
" endif
