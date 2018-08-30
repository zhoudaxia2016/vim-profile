" select compiler
nnoremap <F6> :call SelectCompiler()<cr>
nnoremap <leader>sc :call SelectCompiler()<cr>
nnoremap <leader>m :call <SID>make()<cr>

" quickfix
nnoremap <expr> cn <SID>jumpNextOrFirstError()
nnoremap cp :cp<cr>
nnoremap cf :cf<cr>

let b:justAfterCompile = 1

function SelectCompiler ()
  if (exists('b:compilers'))
    let index = input#radio('Select a compiler', b:compilers)
    exec 'compiler ' . b:compilers[index-1]
  endif
endfunction

func MakeHandler (channel, msg)
  if a:msg != ''
    exe "cadde '" . substitute(a:msg, "'", "\"", "g") . "'"
  endif
  let qflist = getqflist()
  let num = len(qflist)
endfunc

func <SID>make ()
  let b:justAfterCompile = 1
  let cmd = &l:makeprg
  let cmd = substitute(cmd, '%', expand('%'), 'g')
  echom cmd
  let b:compilerJob = job_start(cmd, {
    \ "callback": "MakeHandler"})
endfunc

func <SID>jumpNextOrFirstError ()
  if exists('b:justAfterCompile') && b:justAfterCompile == 1
    let b:justAfterCompile = 0
    return ":cf\<cr>"
  else
    return ":cn\<cr>"
  endif
endfunc
