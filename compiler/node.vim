let current_compiler = "node"

let &l:makeprg = 'node %'

" Error: msg \n at xxx
let &l:errorformat  = '%+A%.%#Error: %m' . ','
let &l:errorformat .= '%Z%*[\ ]at\ %f:%l:%c' . ','
let &l:errorformat .= '%Z%*[\ ]%m (%f:%l:%c)' . ','

" at xxx 
let &l:errorformat .= '%*[\ ]%m (%f:%l:%c)' . ','
let &l:errorformat .= '%*[\ ]at\ %f:%l:%c' . ','

" 以^作为列号情况，是多余的情况
"let &l:errorformat .= '%Z%p^,%A%f:%l,%C%m' . ','

" 去除其他情况
let &l:errorformat .= '%-G%.%#'
