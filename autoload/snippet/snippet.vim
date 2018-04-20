function snippet#snippet#makeSnippet (short, code)
  let abbrStr = ''

  let codeList = split(a:code, '\$')
  for c in codeList
    let abbrStr = abbrStr . c . b:jump_mark
  endfor
  exec 'iabbr  ' . a:short . ' ' . abbrStr . '<c-r>=snippet#snippet#jumpToFirstPos()<cr>' 
endfunc

function snippet#snippet#jumpToFirstPos ()
  let str = "\<esc>gg/" . b:jump_mark . "\<cr>ca" . b:jump_mark_d . "\<c-r>=utils#Eatchar(' ')\<cr>"
  echom str
  return str
endfunc
