nnoremap ,d :silent !git difftool %<cr>
nnoremap ,l :silent !git log \| vim -R -<cr>:redraw<cr>
nnoremap ,s :silent !git status \| vim -R -c 'set filetype=git' -<cr>

au ShellCmdPost * redraw!
