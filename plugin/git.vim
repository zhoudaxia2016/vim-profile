nnoremap ,d :call <SID>gitDiff()<cr>
nnoremap ,l :call tmux#window(#{ cmd: 'git log --oneline ' . expand('%:t') . " \| fzf --ansi --preview='git show {+1} " .  expand('%:t') . "'", root: 0, output: 1, callback: function('<SID>gitLogCb') })<cr>
nnoremap <leader>gb :call <SID>blameInfo()<cr>

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
  echom commit
  call <SID>gitDiff(commit)
endfunc

func <SID>afterOpenCommit ()
  retab
  nnoremap w :wq<cr>
endfunc

func <SID>blameInfo()
  let lineNum = line('.')
  let fileName = expand('%:p')
  let info = [trim(system("git blame -L" . lineNum . "," . lineNum . ' ' . fileName))]
  if match(info[0], "00000000") != 0
    let lineNum = trim(system("git blame " . fileName . "| sed -n '1," . lineNum . "p' | sed -n '/00000000/!p' | wc -l"))
    let info = split(trim(system('git log -L ' . lineNum . ',' . lineNum . ':' . fileName . ' --color=never')), '\n')
  endif
  if has('nvim')
    let buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(buf, 0, -1, v:true, info)
    call nvim_buf_add_highlight(buf, 0, 'TODO', 0, 0, -1)
    call nvim_buf_add_highlight(buf, 0, 'WhiteSpace', 1, 0, 7)
    call nvim_buf_add_highlight(buf, 0, 'WhiteSpace', 2, 0, 5)
    call nvim_buf_add_highlight(buf, 0, 'TabLine', len(info) - 1, 0, -1)
    let s:id = nvim_open_win(buf, v:false, #{ relative:'cursor',row:1,col:0,width:100, height:len(info), border: 'single'})
    au CursorMoved,CmdLineEnter * ++once if nvim_win_is_valid(s:id) | call nvim_win_close(s:id, v:true) | endif
  else
    call popup_atcursor(info, { 'padding': [0, 1, 0, 1] })
  endif
endfunc
