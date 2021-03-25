function Handle(ch, msg)
  echom 'Get Message from edtor api'
  echom a:msg
endfunc
function editorApi#create()
  let ch = ch_open('localhost:5656', {'callback': 'Handle' })
  call ch_evalraw(ch, 'abc')
endfunc
