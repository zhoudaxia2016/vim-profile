let &l:makeprg = 'npm start'

" Error: msg \n at xxx
let &l:errorformat  = '%AError: %m' . ','
let &l:errorformat .= '%AEvalError: %m' . ','
let &l:errorformat .= '%ARangeError: %m' . ','
let &l:errorformat .= '%AReferenceError: %m' . ','
let &l:errorformat .= '%ASyntaxError: %m' . ','
let &l:errorformat .= '%ATypeError: %m' . ','
let &l:errorformat .= '%Z%*[\ ]at\ %f:%l:%c' . ','
let &l:errorformat .= '%Z%*[\ ]%m (%f:%l:%c)' . ','

" at xxx 
let &l:errorformat .= '%*[\ ]%m (%f:%l:%c)' . ','
let &l:errorformat .= '%*[\ ]at\ %f:%l:%c' . ','

" 以^作为列号情况
let &l:errorformat .= '%Z%p^,%A%f:%l,%C%m' . ','

" 去除其他情况
let &l:errorformat .= '%-G%.%#'
