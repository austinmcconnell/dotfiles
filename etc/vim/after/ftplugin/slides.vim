nnoremap <Right> :n<CR>
nnoremap <Left> :N<CR>

let &fillchars = 'eob: '     " replace end-of-buffer fill character (default: ~) with a blank space

autocmd! User GoyoEnter      " remove autocmd to load limelight on GoyoEnter
autocmd! User GoyoLeave      " remove autocmd to unload limelight on GoyoLeave

" Function to handle Goyo initialization
function! s:init_goyo()
  " Only initialize if not already in Goyo mode
  if !exists('#goyo')

    " Store the current tab number
    let s:original_tab = tabpagenr()

    " Enter Goyo mode
    Goyo

    " Close the original tab if it's not the only tab
    if tabpagenr('$') > 1
      " Wait a bit to ensure Goyo has fully initialized
      call timer_start(25, {-> execute('tabclose ' . s:original_tab)})
    endif

  endif
endfunction

" Initialize Goyo for slides
if !exists('g:slides_initialized')
  let g:slides_initialized = 1

  " Wait a bit before initializing Goyo to ensure buffer is fully loaded
  call timer_start(50, {-> s:init_goyo()})
endif
