" vim-localvimrc: project-local settings via .lvimrc files
" https://github.com/embear/vim-localvimrc

let g:localvimrc_sandbox = 0                " disable sandbox (needed for buffer-local let)
let g:localvimrc_ask = 0                    " don't prompt before sourcing
let g:localvimrc_whitelist = [$HOME . '/projects/.*']
let g:localvimrc_event = ['BufRead']        " source before ALE's first lint pass
