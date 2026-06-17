let python_highlight_all=1        " enable all Python syntax highlighting features

setlocal colorcolumn=101          " highlight column showing longer than 100 chars
setlocal autoindent               " copy indent from current line when starting a new line
setlocal smartindent              " insert an indent when needed when starting a new line

if get(g:, 'colors_name', '') !=# 'nord'
  colorscheme nord
  let g:lightline.colorscheme = 'nord'
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endif
