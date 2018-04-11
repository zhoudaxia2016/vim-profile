function! input#radio (question, options)
  let list = ""
  let index = 0
  let len = len(a:options)
  while index < len
    let list = list . "&" . (index + 1) . a:options[index] . "\n"
    let index = index + 1
  endwhile
  echohl NonText
  let sel = confirm(a:question, list)
  echohl None
  return sel
endfunc

function! input#confirm (question)
  echohl Number
  let sel = confirm(a:question, "Yes\nNo")
  echohl None
  return sel%2
endfunc

function! input#input (question)
  echohl Title
  let inp = input(a:question . ":\n")
  echohl None
  return inp
endfunc
