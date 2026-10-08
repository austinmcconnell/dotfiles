" Native comment package (Vim 9.1+) replaces tpope/vim-commentary.
" Provides gc/gcc/gC toggles plus ic/ac comment text objects.
packadd comment

nmap <C-/> gcc
nmap <C-_> gcc
vmap <C-/> gc
vmap <C-_> gc
