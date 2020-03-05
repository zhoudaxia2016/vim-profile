" typescript compiler
let name = 'typescript'
if (!exists('g:current_compiler'))
  let g:current_compiler = name
else
  if (g:current_compiler == name)
    finish
  else
    let g:current_compiler = name
  endif
endif

let &l:makeprg = '/home/zhou/.local/node/bin/tsc %'
let &l:errorformat = '%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m'
