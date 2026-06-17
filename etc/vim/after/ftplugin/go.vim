setlocal noexpandtab              " gofmt uses tabs
setlocal tabstop=4                " display width of a tab
setlocal shiftwidth=4             " indent width
setlocal softtabstop=4            " backspace through tabs

if get(g:, 'colors_name', '') !=# 'everforest'
  colorscheme everforest
  let g:lightline.colorscheme = 'everforest'
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endif
