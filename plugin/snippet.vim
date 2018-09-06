function <SID>generateSnippet ()
  let ft = expand("<amatch>")
  echom ft
  let fn = $HOME . '/.vim/snippets/' . ft . '.json'
  if (file_readable(fn))
    let json = json#readfile(fn)
    call snippet#generateSnippet(json.items, json.models)
  endif
  echom exists('b:moreSnippets')
  if !exists('b:moreSnippets') | return | endif
  if type(get(b:moreSnippets, ft)) == v:t_list
    echom "abc" 
    for ft in get(b:moreSnippets, ft)
      let fn = $HOME . '/.vim/snippets/' . ft . '.json'
      if (file_readable(fn))
	let json = json#readfile(fn)
	call snippet#generateSnippet(json.items, json.models)
      endif
    endfor
  endif
endfunc

au Filetype * call <SID>generateSnippet()
