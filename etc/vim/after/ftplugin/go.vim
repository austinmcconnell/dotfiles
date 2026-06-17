if get(g:, 'colors_name', '') !=# 'everforest'
  colorscheme everforest
  let g:lightline.colorscheme = 'everforest'
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endif
