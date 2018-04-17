" node compiler
let name = 'node'
if (!exists('g:current_compiler'))
  let g:current_compiler = name
else
  if (g:current_compiler == name)
    finish
  else
    let g:current_compiler = name
  endif
endif

" Error: msg \n at xxx
let errorformat  = '%+A%.%#Error: %m' . ','
let errorformat .= '%Z%*[\ ]at\ %f:%l:%c' . ','
let errorformat .= '%Z%*[\ ]%m (%f:%l:%c)' . ','

" at xxx 
let errorformat .= '%*[\ ]%m (%f:%l:%c)' . ','
let errorformat .= '%*[\ ]at\ %f:%l:%c' . ','

" 以^作为列号情况，是多余的情况
"let errorformat .= '%Z%p^,%A%f:%l,%C%m' . ','
"
let cmd = "node %"

let &l:makeprg = cmd
let &l:errorformat = errorformat . '%-G%.%#'
au! QuickFixCmdPost make
