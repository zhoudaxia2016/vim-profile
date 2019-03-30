nnoremap ,d :silent !git difftool %<cr>
nnoremap ,l :silent !git log \| vim -R -<cr>:redraw<cr>
nnoremap ,s :silent !git status \| vim -R -c 'set filetype=gitstatus' -<cr>

nnoremap ,g :popup Gitcmd<cr>
call menu#create('Gitcmd.diff', 'git diff current file', ':silent !git difftool %<cr>', 'n')
call menu#create('&Gitcmd.&status', 'git status', ':silent !git status \| vim -R -c "set filetype=gitstatus" -<cr>', 'n')
call menu#create('Gitcmd.log', 'git log', ':silent !git log \| vim -R -<cr>:redraw<cr>', 'n')

au ShellCmdPost * redraw!
au FileType gitcommit call <SID>afterOpenCommit()
au FileType gitstatus call <SID>afterOpenStatus()

func <SID>afterOpenCommit ()
  startinsert
  retab
  nnoremap w :wq<cr>
endfunc

func <SID>afterOpenStatus ()
  retab
  nnoremap q :q!<cr>
endfunc
