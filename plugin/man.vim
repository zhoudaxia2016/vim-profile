runtime! ftplugin/man.vim
nnoremap <leader>m :call <SID>mapMan()<cr>

function <SID>mapMan ()
  let cmd = input#input('Input command name', 'shellcmd')
  exe "Man " . cmd
endfunc
