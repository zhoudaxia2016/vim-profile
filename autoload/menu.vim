let s:descDeli = '\ --->\ \ '
let s:modeMap = { 'n': 'nnoremenu', 'i': 'inoremenu'}
function! menu#create (name, desc, cmd, mode)
  let mode = s:modeMap[a:mode]
  let menuStr = mode . ' ' . a:name . "<Tab>"
  if a:desc != ''
    let menuStr .= s:descDeli . substitute(a:desc, ' ', '\\ ', 'g')
  endif
  let menuStr .= ' ' . a:cmd
  exe menuStr

endfunc
