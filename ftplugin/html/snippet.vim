if exists('b:did_snippet')
  finish
endif
let b:did_snippet = 1
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
call MakeSnippet('sp', '<span class="keyword">$</span>')

