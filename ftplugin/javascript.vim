" compiler
compiler eslint
let b:compilers = ['node', 'npm']

" include file search
let &l:include = 'import\s*\i*\s*from\|import\|require('

" define search
let &l:define = '^\s*\(var\|let\|const\|class\|import\|function\)'

" path
set path=./node_modules;./
call webdevelop#conf()
