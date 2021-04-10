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
  let job = job#start(a:cmd, #{ out_cb: function('<SID>handleOutput'), exit_cb: function('<SID>HandleExit', [a:callback])})
  return job
endfunc

function job#start(cmd, opts)
  let opts = a:opts
  if has('nvim')
    let nvimOpts = {}
    if has_key(opts, 'out_cb')
      let nvimOpts.on_stdout = {ch, data, name -> opts.out_cb(ch, join(data, ''))}
    endif
    if has_key(opts, 'err_cb')
      let nvimOpts.on_stderr = {ch, data, name -> opts.err_cb(ch, join(data, ''))}
    endif
    if has_key(opts, 'close_cb')
      let nvimOpts.on_exit = {ch, code, type -> opts.close_cb(ch)}
    endif
    return jobstart(a:cmd, nvimOpts)
  else
    return job_start(a:cmd, opts)
  endif
endfunc
