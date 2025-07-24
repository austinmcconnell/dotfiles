" Vim Surround Configuration
" Plugin: https://github.com/tpope/vim-surround

" Custom surroundings for common patterns
" Usage: ysiw<key> to surround word with custom pattern

" Add custom surroundings
" 'e' for erb tags (Ruby)
autocmd FileType eruby let b:surround_101 = "<% \r %>"
autocmd FileType eruby let b:surround_69 = "<%= \r %>"

" 'f' for function calls
let g:surround_102 = "\r()"

" 'c' for code blocks in markdown
autocmd FileType markdown let b:surround_99 = "```\n\r\n```"

" 'i' for italic in markdown
autocmd FileType markdown let b:surround_105 = "*\r*"

" 'b' for bold in markdown
autocmd FileType markdown let b:surround_98 = "**\r**"

" 'l' for links in markdown
autocmd FileType markdown let b:surround_108 = "[\r]()"

" 'd' for div tags in HTML
autocmd FileType html let b:surround_100 = "<div>\n\r\n</div>"

" 's' for span tags in HTML
autocmd FileType html let b:surround_115 = "<span>\r</span>"

" Note: Default mappings are:
" ds<char> - delete surroundings
" cs<old><new> - change surroundings
" ys<motion><char> - add surroundings
" yss<char> - surround entire line
" S<char> - surround selection in visual mode
