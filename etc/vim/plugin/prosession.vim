let g:prosession_on_startup = 0     " Disable auto-loading sessions on startup

let g:Prosession_ignore_expr = {-> !isdirectory('.git')}

nnoremap <leader>S :call fzf#run({'source': prosession#ListSessions(), 'sink': 'Prosession', 'down': '40%'})<CR>
