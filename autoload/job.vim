function <SID>send(ch, msg)
  call ch_sendraw(a:ch, a:msg)
  call ch_close_in(a:ch)
endfunc

function <SID>handleCb(cbs, msg)
  call map(a:cbs, {cb -> 'cb(' . a:msg . ')})
endfunc

function job#open(cmd)
  let callbacks = []
  let job = job_start(cmd, #{ callback: function('<SID>handleCb', [callbacks])})
  let channel = job_getchannel(job)
  let send = {msg -> <SID>send(job, msg)}
  return job
endfunc
