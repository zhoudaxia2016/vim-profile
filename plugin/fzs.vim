function <SID>execute(cmd)
  let list = split(a:cmd, '\s\+')
  if len(list) >= 1
    exec list[1]
  endif
endfunc

function <SID>editFIle(root, key, path)
  let path = a:root . '/' . a:path
  echom path
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
  echom root
  call fzs#run(#{cb: function('<SID>editFIle', [root, 0]), actions: #{ctrl-t: function('<SID>editFIle', [root, 1])}, termOpts: #{cwd: root}, preview: 'cat {}'})
endfunc

nnoremap <leader>p1 :call fzs#run(#{cmd: 'command', isVimCmd: 1, cb: function('<SID>execute')})<cr>
nnoremap <leader>p2 :call <SID>startSearchFile()<cr>
