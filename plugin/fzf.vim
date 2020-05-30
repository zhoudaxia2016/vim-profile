function! <SID>Open()
  echom 2
  let root = utils#findRoot('.git')
  let origin_path = getcwd()
  if root == v:null
    let root = utils#findRoot('package.json')
  endif
  if root == v:null
    let root = '.'
  endif
  echom 3
  let options = {'cwd': root, 'term_name': 'FZF', 'exit_cb': function('s:OpenFile', [root, origin_path]), 'vertical': 0}
  let b:term_buf = term_start('fzf', options)
  echom 4
endfunction

function s:OpenFile(...)
  echom 1
  let path = term_getline(b:term_buf, 1)
  let path = a:1.'/'.path
  if filereadable(path)
    exe 'edit ' . path
  else
    close
  endif
endfunction

nnoremap <expr> <c-p> <SID>Open()
