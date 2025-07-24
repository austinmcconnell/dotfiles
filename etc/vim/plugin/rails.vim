" Vim Rails Configuration
" Plugin: https://github.com/tpope/vim-rails

" Enhanced navigation mappings
" Default mappings: gf, :A, :R, :Emodel, :Eview, :Econtroller

" Quick navigation to common Rails files
nnoremap <leader>rm :Emodel<Space>
nnoremap <leader>rv :Eview<Space>
nnoremap <leader>rc :Econtroller<Space>
nnoremap <leader>rh :Ehelper<Space>
nnoremap <leader>rl :Elayout<Space>
nnoremap <leader>rs :Estylesheet<Space>
nnoremap <leader>rj :Ejavascript<Space>

" Split navigation
nnoremap <leader>rM :Smodel<Space>
nnoremap <leader>rV :Sview<Space>
nnoremap <leader>rC :Scontroller<Space>
nnoremap <leader>rH :Shelper<Space>

" Vertical split navigation
nnoremap <leader>r<C-m> :Vmodel<Space>
nnoremap <leader>r<C-v> :Vview<Space>
nnoremap <leader>r<C-c> :Vcontroller<Space>

" Test running shortcuts
nnoremap <leader>rt :Rails<CR>
nnoremap <leader>rT :.Rails<CR>

" Rails console and server
nnoremap <leader>rco :Rails console<CR>
nnoremap <leader>rse :Rails server<CR>

" Generate shortcuts
nnoremap <leader>rg :Generate<Space>

" Database shortcuts
nnoremap <leader>rdb :Rails dbconsole<CR>
nnoremap <leader>rdm :Rails db:migrate<CR>
nnoremap <leader>rdr :Rails db:rollback<CR>

" Rails-specific settings
augroup rails_settings
    autocmd!
    " Set up Rails-specific abbreviations
    autocmd FileType ruby,eruby iabbrev <buffer> pry binding.pry
    autocmd FileType ruby,eruby iabbrev <buffer> byebug byebug

    " Enhanced syntax highlighting for Rails files
    autocmd BufRead,BufNewFile *.rb,*.rake,Gemfile,Rakefile,config.ru set filetype=ruby
    autocmd BufRead,BufNewFile *.erb set filetype=eruby

    " Auto-completion for Rails methods
    autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
augroup END

" Integration with dispatch for test running
" This allows :Rails to use dispatch for background test execution
let g:rails_default_file='config/database.yml'

" Note: Default Rails.vim mappings:
" gf - Enhanced 'go to file' that understands Rails conventions
" :A - Alternate file (test <-> implementation)
" :R - Related file (controller <-> view)
" :AS, :AV - Alternate in split/vsplit
" :RS, :RV - Related in split/vsplit
