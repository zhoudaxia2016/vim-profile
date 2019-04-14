function! s:out_cb (c, m) abort
  echom "message\n" . a:m
  if a:m =~ '^Content-Length'
    let b:lsp_response_length = split(a:m)[1]
    let response = split(a:m, '\r\n\r\n')
    if len(response) > 1
      let b:lsp_part_response_length = len(response[1])
      let b:lsp_response = response[1]
      echom 11
      if b:lsp_part_response_length >= b:lsp_response_length
        unlet b:lsp_response_length
        unlet b:lsp_part_response_length
        echom 10
        let b:data = json_decode(b:lsp_response)
      endif
    endif
    return
  endif
  if exists('b:lsp_response_length')
    echom 1
    if exists('b:lsp_part_response_length')
      echom 2
      if b:lsp_part_response_length < b:lsp_response_length
        echom 3
        let b:lsp_response .= a:m
        let b:lsp_part_response_length += len(a:m)
        if b:lsp_part_response_length >= b:lsp_response_length
          echom 4
          unlet b:lsp_response_length
          unlet b:lsp_part_response_length
          let b:data = json_decode(b:lsp_response)
        endif
      endif
    else
      echom 5
      let b:lsp_part_response_length = len(a:m)
      let b:lsp_response = a:m
    endif
  endif
endfunc

function! s:out_cb1 (c, m) abort
  echom 'message' . a:m
endfunc
function! s:err_cb (a, b) abort
  echom "error:" . a:a . a:b
endfunc

let b:job = job_start('javascript-typescript-stdio', {"out_cb": function('s:out_cb'), "err_cb": function("s:err_cb"), "mode": "raw"})
let b:ch = job_getchannel(b:job)
let initData = {
      \  'jsonrpc': '2.0',
      \  'id' : 1,
      \  'method': 'initialize',
      \  'params': {
      \      'rootPath': expand('%:p:h'),
      \      'capabilities': {'workspace': {'applyEdit': 'true' }},
      \      'trace': 'off'
      \  }
      \}
function! s:send_data (data)
  let data = json_encode(a:data)
  let data = 'Content-Length: ' . len(data) . "\r\n\r\n" . data
  echom 'send: ' . data
  call ch_sendraw(b:ch, data)
endfunc

"call s:send_data(initData)

function! s:open_file ()
  let text = system('cat '.expand('%'))
  let data = {
        \"textDocument": {
        \  "uri": "file://" . expand('%:p'),
        \  "languageId": &filetype,
        \  "version": 1,
        \  "text": text
        \}
      \}
  let data = {
        \  'jsonrpc': '2.0',
        \  'method': 'textDocument/didOpen',
        \  'params': data
        \}
  call s:send_data(data)
endfunc

"au filetype * call s:open_file()
inoremap <tab> <c-r>=Mycomplete()<cr>

function! Mycomplete ()
  let fn = 'file://' . expand('%:p') 
  let data = {
        \  "textDocument": {
        \    "uri": fn
        \  },
        \  "position": {
        \    "line": line('.') - 1,
        \    "character": col('.') - 1
        \  },
        \  "context": {
        \    "triggerKind": 1
        \  }
        \}
  let data = {
      \  'jsonrpc': '2.0',
      \  'id': 1,
      \  'method': 'textDocument/completion',
      \  'params': data
      \}
  call s:send_data(data)
  return ''
endfunc

function GetLabel (l, k)
  for a in a:l
    if a.kind == a:k
      echo a.label
    endif
  endfor
endfunc
