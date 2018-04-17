" npm compiler
let name = 'npm'
if (!exists('g:current_compiler'))
  let g:current_compiler = name
else
  if (g:current_compiler == name)
    finish
  else
    let g:current_compiler = name
  endif
endif

let errorformat   = '  %l:%c%*[\ ] %m' . ','
let errorformat  .= '%+PERROR in %f' . ','
let errorformat  .= '%+Q✖%.%#' . ','

let cmd = 'npm start'

let &l:makeprg = cmd
let &l:errorformat = errorformat . '%-G%.%#'
au! QuickFixCmdPost make
