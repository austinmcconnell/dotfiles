noremap <C-_> <plug>NERDCommenterToggle

let g:NERDCreateDefaultMappings = 0     " Disable default mapping creation
let g:NERDSpaceDelims = 1               " Add spaces after comment delimiters by default
let g:NERDDefaultAlign = 'left'         " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDCommentEmptyLines = 1         " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1    " Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1       " Enable NERDCommenterToggle to check all selected lines is commented or not
