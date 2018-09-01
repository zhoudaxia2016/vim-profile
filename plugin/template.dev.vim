let s:ext = expand("%:e")
let s:args = {'filename': expand("%")}
let s:tpf = $HOME . '/.vim/templates/files/' . s:ext . '.tpl'
if filereadable(s:tpf)
  exec 'au BufNewFile *.' . s:ext . " call LoadTemplate()"
endif

function! LoadTemplate()
  exec "0r " . s:tpf
  for [key, value] in items(s:args)
    exec ':1,$s/{%' . key . '%}/' . value . '/ge'
  endfor
  let pattern = '{%[^%]*%}'
  while 1
    try
      exec "/" . pattern
      exec "normal! n"
      let key = expand('<cword>')
      let value = input("Input " . key . ":\n")
      exec ':1,$s/{%' . key . '%}/' . value . '/ge'
    catch '.*'
      break
    endtry
  endwhile
endfunc

