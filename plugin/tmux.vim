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

nnoremap <c-p>f :call tmux#window(#{ cmd: '_frg', output: 1, callback: function('<SID>frgCb') })<cr>
nnoremap <c-p>F :call tmux#window(#{ cmd: '_frg', output: 1, callback: function('<SID>frgCb'), root: 0 })<cr>
nnoremap <c-p>p :call tmux#window(#{ cmd: '_fe', output: 1, callback: function('<SID>fzfCb') })<cr>
nnoremap <c-p>P :call tmux#window(#{ cmd: '_fe', output: 1, callback: function('<SID>fzfCb'), root: 0 })<cr>
nnoremap <c-p>d :call tmux#window(#{ cmd: 'cat -n ' . expand('%:p') . " \| fzf", output: 1, callback: function('<SID>searchCurrentFileCb'), root: 0 })<cr>
nnoremap <c-b> :call tmux#window(#{ cmd: 'fzf', output: 1, callback: function('<SID>searchBufferCb'), root: 0, input: 'ls' })<cr>
