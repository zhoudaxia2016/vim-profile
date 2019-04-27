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

let rootDir = utils#findRoot('package.json')
if rootDir != v:null
  let cmd = rootDir . '/node_modules/.bin/eslint %'
else
  let cmd = 'eslint %'
endif

let &l:makeprg = cmd
let &l:errorformat = errorformat . '%-G%.%#'
au! QuickFixCmdPost make
