function snippet#generateSnippet (items, models)
  for _ in a:items
    let sn = get(_, 'snippet', v:null)
    if (sn == v:null)
      let sn = substitute(a:models[_.model], '\$\$', _.name, 'g')
    endif
    exe 'ia <buffer> ' . _.trigger . ' ' . sn . '<c-r>=utils#Eatchar("\\s")<cr>'
  endfor
endfunc
