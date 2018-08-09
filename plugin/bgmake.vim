" select compiler
nnoremap <F6> :call SelectCompiler()<cr>
nnoremap <leader>sc :call SelectCompiler()<cr>
nnoremap <leader>m :call <SID>make()<cr>

function SelectCompiler ()
  if (exists('b:compilers'))
    let index = input#radio('Select a compiler', b:compilers)
    exec 'compiler ' . b:compilers[index-1]
  endif
endfunction

func MakeHandler (channel, msg)
  let msg = substitute(a:msg, '\[[0-9]\{1,3}m', '', 'g')
  for line in split(msg, '\n')
    exe "!echo '" . line . "' >> vimtmpfile" 
  endfor

  cfile vimtmpfile
  copen
endfunc

func MakeExitHandler (channel, msg)
  cfile! errfile.txt
endfunc

func <SID>make ()
  let cmd = &l:makeprg
  let cmd = substitute(cmd, '%', expand('%'), 'g')
  echom cmd
  call job_start(cmd, {
    \ "exit_cb": "MakeExitHandler",
    \ "out_io": "file",
    \ "out_name": "errfile.txt",
    \ "err_io": "file",
    \ "err_name": "errfile.txt"})
endfunc
