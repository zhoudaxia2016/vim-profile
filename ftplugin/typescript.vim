compiler typescript

let s:fn = expand('%:t')
let s:compile_fn = substitute(s:fn, '.ts', '', '') . '.js'
let s:compile_cmd = 'tsc ' . s:fn
let s:compile_job = v:null
let s:bufnr = bufnr()
let s:compile_msg = []

"exec 'vert pedit ' . s:compile_fn
"vert res -30

"au BufWritePost <buffer> call s:compile()

function s:compile_cb(ch, msg)
  call add(s:compile_msg, a:msg)
endfunc

function s:compile_close(ch)
  echom json_encode(s:compile_msg)
  let errors = map(s:compile_msg, {key,val -> matchlist(val, '\(.*\)(\(\d\+\),\(\d\+\))\(.*\)') })
  echom json_encode(errors)
  let errors = map(errors, {key,val -> #{filename: val[1], lnum: val[2], col: val[3], text: val[4]}})
  call setqflist(errors, 'r')
  let s:compile_msg = []
  "vert pedit!
  copen
  cw
endfunc

function s:compile()
  let s:compile_job = job_start(s:compile_cmd, #{close_cb: function('s:compile_close'), callback: function('s:compile_cb')})
endfunc
