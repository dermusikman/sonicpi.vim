if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

" Autocomplete functionality calls Ruby if no sonicpi directives found
if exists("&ofu")
  setlocal omnifunc=sonicpicomplete#Complete
  " Enable words from buffer to be autocompleted unless otherwise set
  if !exists("g:rubycomplete_buffer_loading")
    let g:rubycomplete_buffer_loading = 1
  endif
endif

" Set keymaps in Normal mode
nnoremap <leader>r :silent w !sonic_pi<CR>
nnoremap <leader>S :call system("sonic_pi stop")<CR>
