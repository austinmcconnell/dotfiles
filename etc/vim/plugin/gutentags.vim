let g:gutentags_ctags_tagfile='.git/tags'    " set tagfile location

" Exclude common directories from tag generation
let g:gutentags_ctags_exclude = [
\  '*.git*',
\  '*node_modules*',
\  '*__pycache__*',
\  '*.venv*',
\  '*venv*',
\  '*build*',
\  '*dist*',
\  '*worktrees*',
\]
