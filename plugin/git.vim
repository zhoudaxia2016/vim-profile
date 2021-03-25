nnoremap ,d :silent !git difftool %<cr>
nnoremap ,l :silent !git log \| vim -R -<cr>:redraw<cr>
nnoremap ,s :silent !git status \| vim -R -c 'set filetype=gitstatus' -<cr>
nnoremap <leader>gb :call <SID>blameInfo()<cr>

nnoremap ,g :popup Gitcmd<cr>
call menu#create('Gitcmd.diff', 'git diff current file', ':silent !git difftool %<cr>', 'n')
call menu#create('&Gitcmd.&status', 'git status', ':silent !git status \| vim -R -c "set filetype=gitstatus" -<cr>', 'n')
call menu#create('Gitcmd.log', 'git log', ':silent !git log \| vim -R -<cr>:redraw<cr>', 'n')

au ShellCmdPost * redraw!
au FileType gitcommit call <SID>afterOpenCommit()
au FileType gitstatus call <SID>afterOpenStatus()

func <SID>afterOpenCommit ()
  retab
  nnoremap w :wq<cr>
endfunc

func <SID>afterOpenStatus ()
  retab
  nnoremap q :q!<cr>
endfunc

func <SID>blameInfo()
  let lineNum = line('.')
  let fileName = expand('%:p')
  let info = trim(system('git blame ' . fileName . ' -L ' . lineNum . ',' . lineNum))
  call popup_atcursor(info, { 'padding': [0, 1, 0, 1] })
endfunc
