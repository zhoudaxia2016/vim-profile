function <SID>frgCb(output)
  for line in a:output
    let _ = split(line, ':')
    exec 'tabnew +call\ cursor(' . _[1] . ',' . _[2] . ') ' . _[0]
  endfor
endfunc

function <SID>fzfCb(output)
  for line in a:output
    exec 'tabnew ' . line
  endfor
endfunc

function <SID>searchBufferCb(output)
  for line in a:output
    exec 'tabnew +b' . split(trim(line), ' ')[0]
  endfor
endfunc

function <SID>searchCurrentFileCb(output)
  for line in a:output
    exec 'normal ' . split(trim(line), '\s\+')[0] . 'gg'
  endfor
endfunc

function <SID>openFile(output)
  for line in a:output
    exec 'e ' . trim(line)
  endfor
endfunc

function <SID>openOldFile()
  if len(v:argv) == 1
    call tmux#window(#{ cmd: 'fzf', output: 1, input: 'echo join(v:oldfiles, "\n")', callback: function('<SID>openFile'), root: 0 })
  endif
endfunc

function <SID>echo(output)
  for line in a:output
    echo line
  endfor
endfunc

function <SID>more()
  let cmd = input('Input a vim command> ')
  if cmd != ''
    call tmux#window(#{ cmd: 'fzf -e', output: 1, callback: function('<SID>echo'), root: 0, input: cmd })
  endif
endfunc

function <SID>setKeymap()
  if index(['qf', 'netrw'], &filetype) != -1
    return
  endif
  echom &filetype
  nnoremap <buffer> <cr>f :call tmux#window(#{ cmd: '_frg', output: 1, callback: function('<SID>frgCb') })<cr>
  nnoremap <buffer> <cr>F :call tmux#window(#{ cmd: '_frg', output: 1, callback: function('<SID>frgCb'), root: 0 })<cr>
  nnoremap <buffer> <cr>e :call tmux#window(#{ cmd: '_fe', output: 1, callback: function('<SID>fzfCb') })<cr>
  nnoremap <buffer> <cr>E :call tmux#window(#{ cmd: '_fe', output: 1, callback: function('<SID>fzfCb'), root: 0 })<cr>
  nnoremap <buffer> <cr>c :call tmux#window(#{ cmd: 'cat -n ' . expand('%:p') . " \| fzf", output: 1, callback: function('<SID>searchCurrentFileCb'), root: 0 })<cr>
  nnoremap <buffer> <cr>b :call tmux#window(#{ cmd: 'fzf', output: 1, callback: function('<SID>searchBufferCb'), root: 0, input: 'ls' })<cr>
  nnoremap <buffer> <cr>m :call <SID>more()<cr>
  nnoremap <buffer> <cr>s :set hls!<cr>
endfunc
au BufReadPre * call <SID>setKeymap()
au VimEnter * call <SID>openOldFile()

