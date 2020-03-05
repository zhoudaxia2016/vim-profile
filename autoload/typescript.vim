function s:tsc_cb(ch, msg)
  call add(b:error, a:msg)
endfunc

function s:tsc_close_cb(ch)
  wincmd l
  e
  wincmd h
  echohl WarningMsg
  echom join(b:error)
  echohl None
endfunc

function s:tsc_cmd()
  let b:error = []
  call job_start('tsc ' . expand('%'), { 'callback': function('s:tsc_cb'), 'close_cb': function('s:tsc_close_cb') })
endfunc

function typescript#start_env()
  let fn = expand('%:r')
  let fn = fn . '.js'
  exe 'vs ' . fn
  setlocal autoread
  wincmd h
  au BufWrite  <buffer> call <SID>tsc_cmd()
endfunc
