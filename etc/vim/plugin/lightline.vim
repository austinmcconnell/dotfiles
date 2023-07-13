set noshowmode
let g:lightline = {
    \ 'colorscheme': 'nord',
    \ 'component_function': {
    \     'gitbranch': 'gitbranch#name',
    \     'gitrelativedir': 'LightlineFilename',
    \     'obsessionstatus': 'ObsessionStatus',
    \ },
    \ 'component_expand': {
    \     'linter_checking': 'lightline#ale#checking',
    \     'linter_warnings': 'lightline#ale#warnings',
    \     'linter_errors': 'lightline#ale#errors',
    \     'linter_ok': 'lightline#ale#ok'
    \ },
    \ 'component_type': {
    \     'linter_checking': 'left',
    \     'linter_warnings': 'warning',
    \     'linter_errors': 'error',
    \     'linter_ok': 'left'
    \ },
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \               [ 'gitbranch', 'readonly', 'gitrelativedir', 'modified' ],
    \               [ 'obsessionstatus' ] ],
    \     'right': [ [ 'lineinfo' ],
    \                [ 'percent' ],
    \                [ 'fileformat', 'fileencoding', 'filetype' ],
    \                [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ] ]
    \ },
    \}

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p:h')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return ''
endfunction
