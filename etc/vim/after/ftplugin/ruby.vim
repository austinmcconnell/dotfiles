let g:ruby_recommended_style=1
setlocal colorcolumn=81              " highlight column showing longer than N chars

if get(g:, 'colors_name', '') !=# 'rosepine_moon'
  colorscheme rosepine_moon
  let g:lightline.colorscheme = 'rosepine'
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endif
