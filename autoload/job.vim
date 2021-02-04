let g:job_msgs = {}
function <SID>handleOutput(ch, msg)
  let ch = ch_info(a:ch).id
  if !get(g:job_msgs, ch)
    let g:job_msgs[ch] = ''
  endif
  let g:job_msgs[ch] .= a:msg
endfunc
function <SID>HandleExit(callback, ch, status)
  let ch = ch_info(a:ch).id
  call a:callback(g:job_msgs[ch])
  call remove(g:job_msgs, ch)
endfunc
function job#open(cmd, callback)
  let job = job_start(a:cmd, #{ callback: function('<SID>handleOutput'), exit_cb: function('<SID>HandleExit', [a:callback])})
  return job
endfunc
