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
call MakeSnippet('if', 'if ($) {<cr>$<cr>}')

" ife
call MakeSnippet('ife', 'if ($) {<cr>$<cr>} else {<cr>$<cr>}')

" while
call MakeSnippet('wh', 'while ($) {<cr>$<cr>}')

" switch
call MakeSnippet('sw', 'switch ($) {<cr>case $:<cr>$<cr>break<cr>}')

" function declaration
call MakeSnippet('fu', 'function $ ($) {<cr>$<cr>}')

" function expression
call MakeSnippet('fe', 'let $ = function ($) {<cr>$<cr>}')

" anonymous function
call MakeSnippet('af', 'function ($) {<cr>$<cr>}')

" for
call MakeSnippet('for', 'for (let i = 0$; i ++; i < $) {<cr>$<cr>}')

" for in
call MakeSnippet('fi', 'for $ in $ {<cr>$<cr>}')

" for of
call MakeSnippet('fo', 'for $ of $ {<cr>$<cr>}')

" import default
call MakeSnippet('imd', 'import $ from ')

" import {}
call MakeSnippet('im', 'import {$} from ')

" export default
call MakeSnippet('exd', 'export default ')

" export function
call MakeSnippet('exf', 'export function $ ($) {<cr>$<cr>}')

" export {}
call MakeSnippet('ex', 'export {$}')

" export variable
call MakeSnippet('exv', 'export $ = ')

" array destructuring
call MakeSnippet('ad', 'let [$] = [$]')

" object destructuring
call MakeSnippet('od', 'let {$} = {$}')

" arrow function
call MakeSnippet('arf', '$ => ')

" class declaration
call MakeSnippet('cl', 'class $ {<cr>constructor ($) {<cr>$<cr>}$<cr>}')

" class expression
call MakeSnippet('cle', 'let $ = class $ {<cr>constructor ($) {<cr>$<cr>}$<cr>}')

" new
call MakeSnippet('ne', 'let $ = new $($)')

" promise
call MakeSnippet('pr', 'let $ = new promise($)')
