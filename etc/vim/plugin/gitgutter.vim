highlight! link SignColumn LineNr

nmap <leader>gqf :w<CR>:GitGutterQuickFix\|copen<CR>
nnoremap <silent> <expr> <leader>gd &diff ? ':+clo<CR>' : ':GitGutterDiffOrig<CR>'
