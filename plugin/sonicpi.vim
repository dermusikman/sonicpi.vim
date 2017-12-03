if exists('g:loaded_sonicpi')
  finish
endif
let g:loaded_sonicpi = 1

if !exists('g:sonicpi_command')
  let g:sonicpi_command = 'sonic_pi'
endif

if !exists('g:sonicpi_send')
  let g:sonicpi_send = ''
endif

if !exists('g:sonicpi_stop')
  let g:sonicpi_stop = 'stop'
endif

if !exists('g:vim_redraw')
  let g:vim_redraw = 0
endif

if !exists('g:sonicpi_enabled')
  let g:sonicpi_enabled = 1
endif

if !exists('g:sonicpi_keymaps_enabled')
  let g:sonicpi_keymaps_enabled = 1
endif

" Contextual initialization modelled after tpope's vim-sonicpi
function! sonicpi#detect()
  " Test if Sonic Pi is available. (Pending a PR for sonic-pi-cli.)
  let s:activep = system(g:sonicpi_command.' version 2>/dev/null && echo -n $?')
  if s:activep == 0 && expand(&filetype) == 'ruby' && g:sonicpi_enabled
    if g:sonicpi_keymaps_enabled
      call s:load_keymaps()
    endif
    call s:load_autocomplete()
    call s:load_syntax()
  endif
endfunction

augroup sonicpi
  autocmd!
  autocmd BufNewFile,BufReadPost *.rb call sonicpi#detect()
  autocmd FileType           ruby call sonicpi#detect()
  " Not entirely sure this one will be helpful...
  autocmd VimEnter * if expand('<amatch>')=='\v*.rb'|endif
augroup END

" Autocomplete functionality calls Ruby if no sonicpi directives found
function! s:load_autocomplete()
  if exists("&ofu")
    setlocal omnifunc=sonicpicomplete#Complete
    " Enable words from buffer to be autocompleted unless otherwise set
    if !exists("g:rubycomplete_buffer_loading")
      let g:rubycomplete_buffer_loading = 1
    endif
  endif
endfunction

" Extend Ruby syntax to include Sonic Pi terms
function! s:load_syntax()
  runtime! syntax/sonicpi.vim
endfunction

function! s:SonicPiSendBuffer()
  execute "silent w !" . g:sonicpi_command . " " . g:sonicpi_send
endfunction

function! s:SonicPiStop()
  execute "silent !" . g:sonicpi_command . " " . g:sonicpi_stop
  if g:vim_redraw
    execute ":redraw!"
  endif
endfunction

" Export public API
command! -nargs=0 SonicPiSendBuffer call s:SonicPiSendBuffer()
command! -nargs=0 SonicPiStop call s:SonicPiStop()

" Set keymaps in Normal mode
function! s:load_keymaps()
  nnoremap <leader>r :SonicPiSendBuffer<CR>
  nnoremap <leader>S :SonicPiStop<CR>
endfunction
