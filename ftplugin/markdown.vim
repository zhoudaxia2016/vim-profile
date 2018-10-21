let cmd = 'node ' . $HOME . '/.vim/tools/instant-md2html-server/app.js ' . expand('%:p') . ' floworg'

function! ErrorHandler (ch, msg)
  echoerr "[Err in md2html server] " . a:msg
endfunc
function! OuputHandler (ch, msg)
  echoerr "[Ouput in md2html server] " . a:msg
endfunc

if expand('%:p') !~ '/tmp'
  w
endif
nnoremap <F1> :call job_start(cmd, {'err_cb': 'ErrorHandler'})<cr>
setlocal nowritebackup
autocmd TextChanged,TextChangedI <buffer> silent write
