nnoremap ,d :call <SID>gitDiff()<cr>
nnoremap ,l :call tmux#window(#{ cmd: 'git log --oneline ' . expand('%:t') . " \| fzf --ansi --preview='git show {+1}'", root: 0, output: 1, callback: function('<SID>gitLogCb') })<cr>
nnoremap <leader>gb :call <SID>blameInfo()<cr>

nnoremap ,g :popup Gitcmd<cr>
call menu#create('Gitcmd.diff', 'git diff current file', ':silent !git difftool %<cr>', 'n')
call menu#create('&Gitcmd.&status', 'git status', ':silent !git status \| vim -R -c "set filetype=gitstatus" -<cr>', 'n')
call menu#create('Gitcmd.log', 'git log', ':silent !git log \| vim -R -<cr>:redraw<cr>', 'n')

au ShellCmdPost * redraw!
au FileType gitcommit call <SID>afterOpenCommit()
au FileType gitstatus call <SID>afterOpenStatus()

func <SID>gitDiff(commit = 'HEAD')
  let tempfile = tempname()
  call system('git show ' . a:commit . ':./' . expand('%:t') . ' > ' . tempfile)
  exec 'vert diffs ' . tempfile
endfunc

func <SID>gitLogCb(str)
  let commit = split(a:str[0], ' ')[0]
  call <SID>gitDiff(commit)
endfunc

func <SID>afterOpenCommit ()
  retab
  nnoremap w :wq<cr>
endfunc

func <SID>afterOpenStatus ()
  retab
  nnoremap q :q!<cr>
endfunc

syn match GitEmail ".*@.*" contained
syn match GitAuthorLine "^Author:" contains=GitAuthor,GitEmail
syn match GitAuthor "Author:" contained
hi GitEmail guifg=#EBCB8B
hi GitAuthor guifg=#EBCB8B

func <SID>blameInfo()
  let lineNum = line('.')
  let fileName = expand('%:p')
  let lineNum = trim(system("git blame git.vim | sed -n '1,25p' | sed -n '/00000000/!p' | wc -l"))
  let info = split(trim(system('git log -L ' . lineNum . ',' . lineNum . ':' . fileName . ' --color=never')), '\n')
  echom 'git log -L ' . lineNum . ',' . lineNum . ':' . fileName
  if has('nvim')
    let buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(buf, 0, -1, v:true, info)
    call nvim_buf_add_highlight(buf, 0, 'GitEmail', 1, 0, -1)
    call nvim_buf_add_highlight(buf, 0, 'GitAuthor', 1, 0, -1)
    let s:id = nvim_open_win(buf, v:false, #{ relative:'cursor',row:1,col:0,width:100, height:len(info)})
    au CursorMoved * ++once call nvim_win_close(s:id, v:true)
  else
    call popup_atcursor(info, { 'padding': [0, 1, 0, 1] })
  endif
endfunc
