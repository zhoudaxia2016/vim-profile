" npm compiler
let name = 'eslint'
if (!exists('g:current_compiler'))
  let g:current_compiler = name
else
  if (g:current_compiler == name)
    finish
  else
    let g:current_compiler = name
  endif
endif

let errorformat   = '%*[\ ]%l:%c%*[\ ] %m' . ','
let errorformat  .= '%-P%f' . ','
let errorformat  .= '%-Q✖%.%#' . ','

let cmd = "eslint %"
if &filetype == 'vue'
  let cmd = "eslint -c " . $HOME . '/.vim/compiler/config/eslintrc.js %'
endif

let &l:makeprg = cmd
let &l:errorformat = errorformat . '%-G%.%#'
au! QuickFixCmdPost make

