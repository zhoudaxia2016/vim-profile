function webdevelop#conf ()
  let ft = &filetype
  let flagFile = 'package.json'
  if !exists('g:path_replacement')
    let rootDir = utils#findRoot(flagFile)
    if rootDir == v:null | return | endif
    let g:path_replacement = {}
    let g:path_replacement['@'] = rootDir . 'src'
  endif
  if ft == 'vue' || ft == 'javascript'
    set sua+=.js
    set sua+=.vue
    set isfname+=@-@
    set includeexpr=webdevelop#pathReplace(v:fname,g:path_replacement)
  endif
endfunc

function webdevelop#pathReplace (fname, replacement)
  let fname = a:fname
  for [key, val] in items(a:replacement)
    let fname = substitute(fname, key, val, '')
  endfor
  return fname
endfunc 
