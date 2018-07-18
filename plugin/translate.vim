nnoremap <leader>t :call <SID>translate()<cr>

function! <SID>translate ()
  normal! viwy
  exec "!~/.local/ydcv/src/ydcv.py " . @0
endfunc
