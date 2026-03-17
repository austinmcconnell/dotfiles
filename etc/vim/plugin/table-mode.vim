" Table Mode Configuration
" Plugin: https://github.com/dhruvasagar/vim-table-mode

" Remap prefix to ;m to avoid conflict with TagbarToggle (;t)
let g:table_mode_map_prefix = '<Leader>m'

" Auto-enable for markdown files (buffer-local, no cleanup needed)
augroup table_mode_markdown
  autocmd!
  autocmd FileType markdown silent! TableModeEnable
augroup END

" Use markdown-compatible corner (auto-set for markdown, explicit for safety)
let g:table_mode_corner = '|'
