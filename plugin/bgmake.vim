" select compiler
" nnoremap <F6> :call SelectCompiler()<cr>
" nnoremap <leader>sc :call SelectCompiler()<cr>
 nnoremap <leader>w :call <SID>make()<cr>
 "compiler jenkins

"au BufWritePost * call <SID>make()
autocmd BufNew * if &previewwindow | wincmd L | endif

" quickfix
nnoremap <expr> cn <SID>jumpNextOrFirstError()
nnoremap cp :cp<cr>
nnoremap cl :cf<cr>
let b:justAfterCompile = 1

function SelectCompiler ()
  if (exists('b:compilers'))
    let index = input#radio('Select a compiler', b:compilers)
    exec 'compiler ' . b:compilers[index-1]
  endif
endfunction

func MakeExitHandler (channel, msg)
  if !exists('b:tmpfile') | return | endif
  exe "cg " . b:tmpfile
  let qflist = getqflist()
  let num = len(qflist)
  if (&filetype == 'typescript')
    exec "pedit " . expand('%:r') . '.js'
  endif
  if (num == 0)
    echo "Good job! No error exists."
    cclose
  else
    echohl ErrorMsg
    echo num . " error(s) need you to fix!"
    copen
    echohl None
  endif
endfunc

func <SID>make ()
  let cmd = &l:makeprg
  if (cmd == '')
    return
  endif
  let b:justAfterCompile = 1
  let b:tmpfile = tempname()
  let cmd = substitute(cmd, '%', expand('%'), 'g')
  echom cmd
  call job_start(cmd, {
    \ "exit_cb": "MakeExitHandler",
    \ "out_io": "file",
    \ "out_name": b:tmpfile,
    \ "err_io": "file",
    \ "err_name": b:tmpfile})
  call feedkeys('<cr>')
endfunc

func <SID>jumpNextOrFirstError ()
  if exists('b:justAfterCompile') && b:justAfterCompile == 1
    let b:justAfterCompile = 0
    return ":cfir\<cr>"
  else
    return ":cn\<cr>"
  endif
endfunc
