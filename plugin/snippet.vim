au Filetype * call <SID>generateSnippet()

function <SID>generateSnippet ()
  let ft = expand("<amatch>")
  let fn = $HOME . '/.vim/snippets/' . ft . '.json'
  if (file_readable(fn))
    let json = json#readfile(fn)
    call snippet#generateSnippet(json.items, json.models)
  endif
  if !exists('b:moreDicts') | return | endif
  if type(get(b:moreDicts, ft)) == v:t_list
    for ft in get(b:moreSnippets, ft)
      let fn = $HOME . '/.vim/snippets/' . ft . '.json'
      if (file_readable(fn))
	let json = json#readfile(fn)
	call snippet#generateSnippet(json.items, json.models)
      endif
    endfor
  endif
endfunc

let b:moreSnippets = {
  \ 'vue': ['javascript']
  \}
