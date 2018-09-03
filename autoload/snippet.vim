function snippet#generateSnippet (items, models)
  if !exists('b:existSnippets')
    let b:existSnippets = {}
  endif
  for _ in a:items
    let sn = get(_, 'snippet', v:null)
    let trigger = _.trigger
    if (get(b:existSnippets, trigger, 0) != 0)
      echoerr "The name " . _.name . " trigger " . trigger . " exists"
    endif
    let b:existSnippets[trigger] = 1
    if (sn == v:null)
      let sn = substitute(a:models[_.model], '\$\$', _.name, 'g')
    endif
    exe 'ia <buffer> ' . trigger . ' ' . sn . '<c-r>=utils#Eatchar("\\s")<cr>'
  endfor
endfunc
