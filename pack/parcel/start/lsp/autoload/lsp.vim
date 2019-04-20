"function! s:base_out_callback (callback, message, data) abort
"  if a:data =~ '^Content-Length'
"    let b:lsp_response_length = split(a:data)[1]
"    let response = split(a:data, '\r\n\r\n')
"    if len(response) > 1
"      let b:lsp_part_response_length = len(response[1])
"      let b:lsp_response = response[1]
"      if b:lsp_part_response_length >= b:lsp_response_length
"        unlet b:lsp_response_length
"        unlet b:lsp_part_response_length
"        call a:callback(json_decode(b:lsp_response))
"      endif
"    endif
"    return
"  endif
"  if exists('b:lsp_response_length')
"    if exists('b:lsp_part_response_length')
"      if b:lsp_part_response_length < b:lsp_response_length
"        let b:lsp_response .= a:data
"        let b:lsp_part_response_length += len(a:data)
"        if b:lsp_part_response_length >= b:lsp_response_length
"          unlet b:lsp_response_length
"          unlet b:lsp_part_response_length
"          call a:callback(json_decode(b:lsp_response).result)
"        endif
"      endif
"    else
"      let b:lsp_part_response_length = len(a:data)
"      let b:lsp_response = a:data
"    endif
"  endif
"endfunc
"
"let b:job = job_start('javascript-typescript-stdio', {"mode": "raw"})
"let b:ch = job_getchannel(b:job)
"let initData = {
"      \  'jsonrpc': '2.0',
"      \  'id' : 1,
"      \  'method': 'initialize',
"      \  'params': {
"      \      'rootPath': expand('%:p:h'),
"      \      'capabilities': {'workspace': {'applyEdit': 'true' }},
"      \      'trace': 'off'
"      \  }
"      \}
"function! s:send_data (data, callback)
"  let data = json_encode(a:data)
"  let data = 'Content-Length: ' . len(data) . "\r\n\r\n" . data
"  call ch_setoptions(b:ch, {'callback': function('s:out_cb', [a:callback])})
"  call ch_sendraw(b:ch, data)
"endfunc
"
"call s:send_data(initData, function('s:out_cb1'))
"
"function! s:open_file ()
"  let text = system('cat '.expand('%'))
"  let data = {
"        \"textDocument": {
"        \  "uri": "file://" . expand('%:p'),
"        \  "languageId": &filetype,
"        \  "version": 1,
"        \  "text": text
"        \}
"      \}
"  let data = {
"        \  'jsonrpc': '2.0',
"        \  'method': 'textDocument/didOpen',
"        \  'params': data
"        \}
"  call s:send_data(data, function('s:out_cb1'))
"endfunc
"
"au filetype * call s:open_file()
"
"function s:CompleteCb (data)
"  echom 'complete'
"  if has_key(a:data, 'items')
"    echom 'has'
"    let items = map(a:data.items, 'v:val.label')
"    let items = filter(items, 'v:val =~ "^" . g:lsp_complete_base')
"    echom 'x' . string(items)
"    call complete(col('.'), items)
"  endif
"endfunc
"
"fun! CompleteFunc(findstart, base)
"  if a:findstart
"    " locate the start of the word
"    let line = getline('.')
"    let start = col('.') - 1
"    while start > 0 && line[start - 1] =~ '\a'
"      let start -= 1
"    endwhile
"    let g:lsp_complete_start = start
"    return start
"  else
"    " find months matching with "a:base"
"    let g:lsp_complete_base = a:base
"    call Mycomplete()
"    return v:none
"  endif
"endfunc
"
"function! Mycomplete ()
"  let fn = 'file://' . expand('%:p') 
"  let data = {
"        \  "textDocument": {
"        \    "uri": fn
"        \  },
"        \  "position": {
"        \    "line": line('.') - 1,
"        \    "character": col('.') - 1
"        \  },
"        \  "context": {
"        \    "triggerKind": 1
"        \  }
"        \}
"  let data = {
"      \  'jsonrpc': '2.0',
"      \  'id': 1,
"      \  'method': 'textDocument/completion',
"      \  'params': data
"      \}
"  call s:send_data(data, function('s:CompleteCb'))
"  return ''
"endfunc
"
"set cfu=CompleteFunc
