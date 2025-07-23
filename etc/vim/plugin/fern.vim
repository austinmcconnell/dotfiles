" noremap <silent> <leader>n :Fern . -drawer -width=35 -toggle -reveal=%<CR><C-w>=
noremap <silent> <leader>d :Fern . -drawer -width=35 -toggle -reveal=%<CR><C-w>=
noremap <silent> <leader>. :Fern %:h -drawer -width=35 -toggle<CR><C-w>=


let g:fern#disable_default_mappings = 1
let g:fern#default_hidden = 1
let g:fern#renderer#default#leading = "  "

" Add dirs and files inside the brackets that need to remain hidden
let hide_dirs  = '^\%(\.git\|.venv|venv|node_modules\)$'  " here you write the dir names
let hide_files = '\%(\.swp\)\+'    " here you write the file names

let g:fern#default_exclude = hide_dirs . '\|' . hide_files  " here you exclude them

function! FernInit() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer> d <Plug>(fern-action-remove)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> M <Plug>(fern-action-rename)
  nmap <buffer> h <Plug>(fern-action-hidden-toggle)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> - <Plug>(fern-action-mark)
  nmap <buffer> _ <Plug>(fern-action-mark-children:leaf)
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer><nowait> < <Plug>(fern-action-leave)
  nmap <buffer><nowait> > <Plug>(fern-action-enter)
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern setlocal norelativenumber | setlocal nonumber | call FernInit()
augroup END
