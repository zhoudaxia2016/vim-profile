function <SID>editFIle(root, key, path)
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
  let root = utils#findRoot('.git')
  let origin_path = getcwd()
  if root == v:null
    let root = utils#findRoot('package.json')
  endif
  if root == v:null
    let root = '.'
  endif
  call fzs#run(#{cb: function('<SID>editFIle', [root, 0]), actions: #{ctrl-t: function('<SID>editFIle', [root, 1])}, termOpts: #{cwd: root}, preview: 'cat {}'})
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

nnoremap <leader>p1 :call <SID>startSearchFile()<cr>
nnoremap <leader>p2 :call fzs#run(#{cmd: 'ls', isVimCmd: 1, cb: function('<SID>switchBuffer')})<cr>
