function snippet#snippet#makeSnippet (short, code)
  let abbrStr = ''

  let codeList = split(a:code, '\$')
  for c in codeList
    let abbrStr = abbrStr . c . g:jump_mark
  endfor
  exec 'iabbr <buffer>  ' . a:short . ' ' . abbrStr . '<c-r>=snippet#snippet#jumpToFirstPos()<cr>' 
endfunc

function snippet#snippet#jumpToFirstPos ()
  let str = "\<esc>gg/" . g:jump_mark . "\<cr>ca" . g:jump_mark_d . "\<c-r>=utils#Eatchar(' ')\<cr>"
  echom str
  return str
endfunc
