" Check common FZF installation locations
if isdirectory('/opt/homebrew/opt/fzf')
  set rtp+=/opt/homebrew/opt/fzf
elseif isdirectory('/usr/local/opt/fzf')
  set rtp+=/usr/local/opt/fzf
endif

let g:fzf_layout = { 'down': '40%' }

nmap <silent> <C-p> :Files<CR>
nnoremap <Leader>b :Buffers<CR>
