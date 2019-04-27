func operator#new (key, opf)
  let funcName = substitute(string(a:opf), "'", "", "g")
  let funcName = substitute(funcName, 'function(\([^)]\+\))', '\1', '')
  exe "nnoremap <buffer> <silent> " . a:key . ' :set opfunc=' . funcName . '<cr>g@'
endfunc
