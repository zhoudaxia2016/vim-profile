function! s:get_completelist(completefunc, findstart, base)
  exec 'let completelistOrStart = ' . a:completefunc . '(' . a:findstart . ', "' . a:base . '")'
  return completelistOrStart
endfunction

" The order is important here, tags without attributes go last.
" HTML is left out, it will be used when there is no match.
let s:languages = [
      \   { 'name': 'htmlcomplete#CompleteTags', 'pairs': ['<template', '</template>'] },
      \   { 'name': 'csscomplete#CompleteCSS', 'pairs': ['<style', '</style>'] },
      \   { 'name': 'javascriptcomplete#CompleteJS', 'pairs': ['<script', '</script>'] },
      \ ]

function! vuecomplete#CompleteVUE(findstart, base)
  for language in s:languages
    let pos = getpos('.')[1:]
    let opening_tag_line = searchpair(language.pairs[0], '', language.pairs[1], 'bWr')
    call cursor(pos)

    if opening_tag_line
      let completelistOrStart = s:get_completelist(language.name, a:findstart, a:base)
      break
    endif
  endfor

  return completelistOrStart
endfunction

