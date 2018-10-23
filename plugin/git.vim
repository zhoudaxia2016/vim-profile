nnoremap ,d :silent !git difftool %<cr>
nnoremap ,l :silent !git log \| vim -R -<cr>:redraw<cr>
nnoremap ,s :silent !git status \| vim -R -c 'set filetype=gitstatus' -<cr>
nnoremap ,c :!git commit -a<cr>
nnoremap ,a :!git add -A && git commit -a<cr>
nnoremap ,q :!git push<cr>

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
