" compiler
compiler npm
let b:compilers = ['node', 'npm']

" dict
setlocal dictionary+=~/.vim/dict/javascript.dict
setlocal thesaurus+=~/.vim/dict/thesaurus/javascript.dict

" include file search
let &l:include = 'import\s*\i*\s*from\|import\|require('
set includeexpr=ExpandFname(v:fname)

function! ExpandFname (fn)
  let fn = substitute(a:fn, '^\.*', '', 'g')
  if (match(fn, '\.') !=  -1)
    return a:fn
  else
    return a:fn . '.js'
  endif
endfunction

" define search
let &l:define = '^\s*\(var\|let\|const\|class\|import\|function\)'
