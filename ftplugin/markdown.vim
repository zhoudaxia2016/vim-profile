let cmd = 'node ' . $HOME . '/.vim/tools/instant-md2html-server/app.js ' . expand('%:p') . ' floworg'

function ErrorHandler (ch, msg)
  echoerr "[Err in md2html server] " . a:msg
endfunc

let job = job_start(cmd, {'err_cb': 'ErrorHandler'})
setlocal nowritebackup
