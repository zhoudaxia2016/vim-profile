function! input#radio (question, options)
  let list = ""
  let index = 0
  let len = len(a:options)
  while index < len
    let list = list . "&" . (index + 1) . a:options[index] . "\n"
    let index = index + 1
  endwhile
  let sel = confirm(a:question, list)
  return sel
endfunc

function! input#confirm (question)
  echohl Number
  let sel = confirm(a:question, "Yes\nNo")
  echohl None
  return sel%2
endfunc

function! input#input (...)
  let question = a:1
  echohl Title
  if (a:0 > 1)
    let completeType = a:2
    let inp = input(question . ":\n", '',  completeType)
  else
    let inp = input(question . ":\n")
  endif
  echohl None
  return inp
endfunc
