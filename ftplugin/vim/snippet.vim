let s:abbrSet = {}

function! MakeSnippet(abbr, code)
  if has_key(s:abbrSet, a:abbr)
    echoe "Abbreviation exists!"
    return
  endif
  let s:abbrSet[a:abbr] = 1
  call snippet#snippet#makeSnippet(a:abbr, a:code)
endfunc

" if
call MakeSnippet('if', 'if ($)<cr>$<cr>endif')

" if else
call MakeSnippet('ife', 'if ($)<cr>$<cr>else<cr>$<cr>endif')

" function
call MakeSnippet('fu', 'function $ ($)<cr>$<cr>endfunc')

" function!
call MakeSnippet('fuu', 'function! $ ($)<cr>$<cr>endfunc')

" for
call MakeSnippet('for', 'for $ in $<cr>$<cr>endfor')

" if exists
call MakeSnippet('ex', 'if exists($)<cr>finish<cr>endif')

" try catch
call MakeSnippet('tr', 'try $<cr>$<cr>catch $<cr>$<cr>endtry')

" while
call MakeSnippet('wh', 'while $<cr>$<cr>endw')

