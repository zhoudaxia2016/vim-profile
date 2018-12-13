exec 'au BufNewFile *' . " call LoadTemplate()"

function! LoadTemplate()
  let ft = &filetype
  let args = {'filename': expand("%")}
  let tpf = $HOME . '/.vim/templates/files/' . ft . '.tpl'

  if filereadable(tpf)
    exec "r " . tpf
    1,1delete
  else
    return
  endif

  for [key, value] in items(args)
    exec ':1,$s/{%' . key . '%}/' . value . '/ge'
  endfor
  let pattern = '{%[^%]*%}'

  redraw
  while 1
    try
      exec "/" . pattern
      exec "normal! n"
      let key = expand('<cword>')
      let value = input#input("Input " . key . ":\n")
      exec ':1,$s/{%' . key . '%}/' . value . '/ge'
    catch '.*'
      call feedkeys('<cr>')
      break
    endtry
  endwhile
endfunc

