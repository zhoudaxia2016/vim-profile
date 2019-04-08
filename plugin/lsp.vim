function! s:out_cb (c, m) abort
  echom "message:" . a:m
endfunc
function! s:err_cb (a, b) abort
  echom "error:" . a:a . a:b
endfunc

let job = job_start('typescript-language-server --stdio', {"out_cb": function('s:out_cb'), "err_cb": function("s:err_cb"), "mode": "raw"})
let initData = {
      \  'jsonrpc': '2.0',
      \  'id' : 1,
      \  'method': 'initialize',
      \  'params': {
      \      'rootUri': 'file:///home/zhou/pratices/butm/',
      \      'rootPath': '/home/zhou/pratices/butm/',
      \      'capabilities': {'workspace': {'applyEdit': 'true' }},
      \      'processId': getpid(),
      \      'trace': 'off'
      \  }
      \}
let initData = json_encode(initData)
let data = 'Content-Length: ' . len(initData) . "\r\n\r\n" . initData
let ch = job_getchannel(job)
"call ch_sendraw(ch, data)
