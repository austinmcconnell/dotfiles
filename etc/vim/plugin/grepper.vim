nnoremap <leader>f :Grepper -tool git<cr>
nnoremap <leader>F :Grepper -tool rg<cr>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>

command! Todo :Grepper -tool git -query '\(TODO\|FIXME\)'
