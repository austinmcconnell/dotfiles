" Check common FZF installation locations
if isdirectory('/opt/homebrew/opt/fzf')
  set rtp+=/opt/homebrew/opt/fzf
elseif isdirectory('/usr/local/opt/fzf')
  set rtp+=/usr/local/opt/fzf
endif

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.6 } }
let g:fzf_action = {
  \ 'ctrl-h': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_vim = {}
let g:fzf_vim.files_options = ['--prompt', '> ']

nnoremap <silent> <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>? :Lines<CR>
nnoremap <leader>h :History<CR>

autocmd! FileType fzf tnoremap <buffer> <Esc> <C-c>
