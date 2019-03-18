function <SID>generateSnippet ()
  if exists('b:loadSnippetPlugin')
    return
  else
    let b:loadSnippetPlugin = 1
  endif
  let ft = expand("<amatch>")
  let fn = $HOME . '/.vim/snippets/' . ft . '.json'
  if (file_readable(fn))
    let json = json#readfile(fn)
    call snippet#generateSnippet(json.items, json.models)
  endif
  if !exists('b:moreSnippets') | return | endif
  if type(get(b:moreSnippets, ft)) == v:t_list
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
inoremap <c-j> <esc>/()\\|{}<cr>a
inoremap <c-b> <esc>?()\\|{}<cr>a
