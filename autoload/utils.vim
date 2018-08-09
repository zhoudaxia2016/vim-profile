func utils#Eatchar(pat)
  let c = nr2char(getchar(0))
  echom a:pat
  return (c =~ a:pat) ? '' : c
endfunc

func utils#findRoot (flagFileOrDir)
  let cur = ''
  let c = 0
  while (c < 10)
    let c += 1
    if file_readable(cur . a:flagFileOrDir) || isdirectory(cur . a:flagFileOrDir)
      return cur
    endif
    let cur .= '../'
  endwhile
  return v:null
endfunc
