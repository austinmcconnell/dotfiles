let g:Prosession_ignore_expr = {-> !isdirectory('.git')}

nnoremap <leader>s :call fzf#run({'source': prosession#ListSessions(), 'sink': 'Prosession', 'down': '40%'})<CR>
