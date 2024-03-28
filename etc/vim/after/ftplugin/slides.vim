nnoremap <Right> :n<CR>
nnoremap <Left> :N<CR>

let &fillchars = 'eob: '     " replace end-of-buffer fill character (default: ~) with a blank space

"This is not working. Behaves really weirdly. Why?
if !exists('#goyo')
    Goyo
endif
