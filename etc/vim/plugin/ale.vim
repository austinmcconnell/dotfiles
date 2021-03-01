let g:ale_fix_on_save = 1
let g:ale_open_list=0                         " automatically open location list when issues found
let g:ale_lint_on_text_changed='always'       " run linter when text changed in insert or normal mode
let g:ale_completion_enabled = 1              " turn on ale completion
let g:ale_set_balloons=1                      " show help documentation in popups

nnoremap gd :ALEGoToDefinition<CR>
nnoremap gr :ALEFindReferences<CR>
nnoremap gR :ALERename<CR>
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call ale#hover#ShowAtCursor()
  endif
endfunction
