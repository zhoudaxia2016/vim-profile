function! <SID>Emmet()
  let start = col('.') - 1
  let line = getline('.')
  while start > 0 && line[start - 1] !~ '\s'
    let start -= 1
  endwhile
  let trigger = line[start:]
  return trigger
endfunction
inoremap <expr> <c-e> <SID>Emmet()
