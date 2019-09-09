vertical res 20
nmap <buffer> h -
nmap <buffer> l <cr>
nmap <buffer> <c-l> <c-w><c-l>

nnoremap <buffer> <leader><leader> :call <SID>grep()<cr>

function <SID>grep ()
  let res = execute('normal qf')
  let fileMsg = split(trim(res), '\s\+')
  let search = input#input("你要搜索的东西是")
  if (search != '')
    exe "tabnew"
    exe "vim! /" . search . '/ ' . fileMsg[-1] . '/**/*'
    let g:grepQuickfixList = getqflist()
  endif
endfunc
