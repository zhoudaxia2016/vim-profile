if exists('b:did_snippet')
  finish
endif
let s:abbrSet = {}

runtime ftplugin/javascript/snippet.vim 

function! MakeSnippet(abbr, code)
  if has_key(s:abbrSet, a:abbr)
    echoe "Abbreviation exists!"
    return
  endif
  let s:abbrSet[a:abbr] = 1
  call snippet#snippet#makeSnippet(a:abbr, a:code)
endfunc


" component

" data
call MakeSnippet('da', 'da () {$<cr>return $<cr>}')

" lifecycle hooks
let lifecycles = [{ 'name': 'beforeCreate', 'abbr': 'bc' },{ 'name': 'created', 'abbr': 'cr' },{ 'name': 'beforeMount', 'abbr': 'bm' },{ 'name': 'mounted', 'abbr': 'mo' },{ 'name': 'beforeUpdate', 'abbr': 'bu' },{ 'name': 'updated', 'abbr': 'up' },{ 'name': 'beforeDestroy', 'abbr': 'bd' },{ 'name': 'destroy', 'abbr': 'de' }]
for lc in lifecycles
  call MakeSnippet(lc.abbr, lc.name . ' () {<cr>$<cr>}')
endfor

let b:did_snippet = 1
