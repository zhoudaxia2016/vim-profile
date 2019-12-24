function ErrorHandler (ch, err)
  echom a:err
  echom a:ch
endfunc 
let cmd = 'node ' . $HOME . '/.vim/tools/instant-md2html-server/main.js ' . expand('%:p')
"let job = job_start(cmd, {'err_cb': 'ErrorHandler'})
