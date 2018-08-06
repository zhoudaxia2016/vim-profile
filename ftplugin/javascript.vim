" compiler
compiler eslint
let b:compilers = ['node', 'npm']

" include file search
let &l:include = 'import\s*\i*\s*from\|import\|require('
set includeexpr=ExpandFname(v:fname)

function! ExpandFname (fn)
  let exts = ['js', 'vue']
  if file_readable(a:fn) | return a:fn | endif
  for ext in exts
    let fn = a:fn . '.' . ext
    if file_readable(fn)
      return fn
    endif
  endfor
  return a:fn
endfunction

" define search
let &l:define = '^\s*\(var\|let\|const\|class\|import\|function\)'

" path
set path=./node_modules;./
