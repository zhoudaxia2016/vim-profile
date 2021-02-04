function! <SID>emmetCb(expand)
  let start = 0
  let currentLine = line('.')
  let placeholders = []
  while 1
    let m = match(a:expand, '@@', start)
    if m == -1
      break
    endif
    call add(placeholders, m + 1)
    let start = m + 2
  endwhile
  call setline(line('.'), a:expand)
  for _ in placeholders
    call prop_add(currentLine, _, #{type: 'emmet-jump', length: 2})
  endfor
  normal 0
  inoremap <tab> <c-r>=EmmetJump()<cr>
  echom '---'
  echom a:expand
  call EmmetJump()
endfunc

function! <SID>emmet()
  let start = col('.') - 1
  let line = getline('.')
  while start > 0 && line[start - 1] !~ '\s'
    let start -= 1
  endwhile
  let trigger = line[start:]
  call job#open('node /home/zhou/.vim/tools/emmet.js ' . trigger, function('<SID>emmetCb'))
  return ''
endfunction

function EmmetJump()
  let textProps = prop_find(#{ type: 'emmet-jump'})
  echom textProps
  if !empty(textProps)
    call cursor(textProps.lnum, textProps.col)
  else
    iunmap <tab>
  endif
  return ''
endfunc
call prop_type_add('emmet-jump', #{highlight: 'Number'})
inoremap <expr> <c-e> <SID>emmet()
