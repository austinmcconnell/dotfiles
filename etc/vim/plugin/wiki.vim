" wiki.vim - Personal knowledge management
" Use WIKI_ROOT environment variable, fallback to default location
let g:wiki_root = !empty($WIKI_ROOT) ? $WIKI_ROOT : expand('~/Library/CloudStorage/SynologyDrive-Home/wiki')

" Use markdown files
let g:wiki_filetypes = ['md']
let g:wiki_link_target_type = 'md'

" Journal configuration (daily notes)
" Separate journal from both commonplace and zettelkasten
let g:wiki_journal = {
      \ 'root': g:wiki_root . '/journal',
      \ 'name': 'journal',
      \ 'frequency': 'daily',
      \ 'date_format': {
      \   'daily' : '%Y-%m-%d',
      \ },
      \}

" FZF integration for fast navigation
let g:wiki_select_method = {
      \ 'pages': function('fzf#vim#files'),
      \ 'tags': function('fzf#vim#grep'),
      \}

" Per-directory link creation behavior
augroup WikiLinkBehavior
  autocmd!
  " Zettelkasten: timestamp-based filenames for atomic notes
  autocmd BufEnter */wiki/zettelkasten/*.md let b:wiki_link_creation = {
        \ 'md': {
        \   'link_type': 'md',
        \   'url_extension': '.md',
        \   'url_transform': { x -> strftime('%Y%m%d%H%M') . '-' . substitute(tolower(x), '\s\+', '-', 'g') },
        \ },
        \}
  " Commonplace: descriptive filenames for collected content
  autocmd BufEnter */wiki/commonplace/*.md let b:wiki_link_creation = {
        \ 'md': {
        \   'link_type': 'md',
        \   'url_extension': '.md',
        \   'url_transform': { x -> substitute(tolower(x), '\s\+', '-', 'g') },
        \ },
        \}
augroup END

" Custom commands for different note-taking areas
command! WikiCommonplace :execute 'e ' . g:wiki_root . '/commonplace/index.md'
command! WikiZettel :execute 'e ' . g:wiki_root . '/zettelkasten/index.md'

" Custom global mappings (override defaults for better ergonomics)
let g:wiki_mappings_global = {
      \ '<plug>(wiki-index)': '<leader>ww',
      \ '<plug>(wiki-journal)': '<leader>wj',
      \ '<plug>(wiki-pages)': '<leader>wp',
      \ '<plug>(wiki-tags)': '<leader>wt',
      \ '<plug>(wiki-open)': '<leader>wn',
      \}

" Key mappings reference:
" <leader>ww - Open wiki index
" <leader>wj - Open today's journal
" <leader>wp - Search wiki pages (FZF)
" <leader>wt - Search wiki tags (FZF)
" <leader>wn - Open/create new page
" <CR> - Follow/create link under cursor (buffer-local, auto-mapped)
" <BS> - Go back to previous page (buffer-local, auto-mapped)
" <leader>wr - Rename current page (buffer-local, auto-mapped)
