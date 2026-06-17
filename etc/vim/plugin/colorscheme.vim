" Switch colorscheme and sync lightline theme (no-op if already active)
function! SetColorscheme(scheme, lightline_theme) abort
  if get(g:, 'colors_name', '') !=# a:scheme
    execute 'colorscheme' a:scheme
    let g:lightline.colorscheme = a:lightline_theme
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
  endif
endfunction
