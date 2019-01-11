au Filetype * call <SID>setDict()
set iskeyword+=-

function <SID>setDict ()
  let ft = expand("<amatch>")
  exe "setlocal dictionary+=~/.vim/dict/" . ft . ".dict"
  exe "setlocal thesaurus+=~/.vim/dict/thesaurus/" . ft . ".dict"
  if !exists('b:moreDicts') | return | endif
  if type(get(b:moreDicts, ft)) == v:t_list
    for dict in get(b:moreDicts, ft)
      exe "setlocal dictionary+=~/.vim/dict/" . dict . ".dict"
    endfor
  endif
endfunc

let b:moreDicts = {
  \ "vue": ['javascript', 'css'],
  \ "html": ['javascript', 'css'],
  \ "wxml": ['mp'],
  \ "wxss": ['mp']
  \}
