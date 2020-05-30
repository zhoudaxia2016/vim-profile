function <SID>editFIle(key, root, path)
  let path = a:root . '/' . a:path
  if filereadable(path)
    if a:key == 1
      exe 'tabnew ' . path
    else
      exe 'edit ' . path
    endif
  endif
endfunc

function! <SID>startSearchFile()
  call fzs#run(#{cb: function('<SID>editFIle', [0]), actions: #{ctrl-t: function('<SID>editFIle', [1])}, preview: 'cat {}', setRoot: 1})
endfunc

function! <SID>switchBuffer(param)
  let param = split(a:param)
  if len(param) == 0
    return
  endif
  let num = param[0]
  let winid = win_findbuf(num)
  if len(winid) == 0
    exe 'vertical sbuffer ' . num
    return
  endif
  let tabwin = win_id2tabwin(winid[0])
  if tabwin[0] != 0 || tabwin[1] != 0
    exe 'tabn ' . tabwin[0]
    exe 'sbuffer ' . num
  endif
endfunc

function! <SID>agSearch(root, param)
  if a:param == ''
    return
  endif
  let params = split(a:param, ':')
  exe 'tabnew ' . a:root . '/' . params[0]
  exe 'normal ' . params[1] . 'gg'
endfunc

function! <SID>jumpLine(param)
  let param = split(a:param)
  exe 'normal ' . param[0] . 'gg'
endfunc

nnoremap <leader>pf :call fzs#run(#{cb: function('<SID>editFIle', [0]), actions: #{ctrl-t: function('<SID>editFIle', [1])}, preview: 'cat {}', setRoot: 1})<cr>
nnoremap <leader>pb :call fzs#run(#{cmd: 'ls', isVimCmd: 1, cb: function('<SID>switchBuffer')})<cr>
nnoremap <leader>pa :call fzs#run(#{cmd: 'ag --noheading .', setRoot: 1, cb: function('<SID>agSearch'), fzfOpts: '-0 -1 --delimiter : --nth 3..'})<cr>
nnoremap <leader>wl :call fzs#run(#{cmd: 'cat -n ' . expand('%:p'), cb: function('<SID>jumpLine')})<cr>