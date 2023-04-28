" nnoremap <leader>f :Grepper -tool git<cr>
nnoremap <leader>F :Grepper -tool ag<cr>
nnoremap <leader>* :Grepper -tool ag -cword -noprompt<cr>

command! Todo :Grepper -tool git -query '\(TODO\|FIXME\)'
