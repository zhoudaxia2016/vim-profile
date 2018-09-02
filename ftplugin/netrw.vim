nmap <buffer> h -
nmap <buffer> l <cr>

nnoremap <buffer> <leader><leader> :call <SID>grep()<cr>

function <SID>grep ()
  let res = execute('normal qf')
  let fileMsg = split(trim(res), '\s\+')
  let search = input#input("你要搜索的东西是")
  if (search != '')
    exe "vim! /" . search . '/ ' . fileMsg[-1] . '/**/*'
  endif
endfunc
