func utils#Eatchar(pat)
  let c = nr2char(getchar(0))
  echom a:pat
  return (c =~ a:pat) ? '' : c
endfunc
