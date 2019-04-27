function! <SID>Open()
  let root = utils#findRoot('.git')
  let origin_path = getcwd()
  if root == v:null
    let root = utils#findRoot('package.json')
  endif
  if root == v:null
    let root = '.'
  endif
  let options = {'cwd': root, 'term_name': 'FZF', 'exit_cb': function('s:OpenFile', [root, origin_path]), 'vertical': 1}
  let b:term_buf = term_start('fzf', options)
endfunction

function s:OpenFile(...)
  let path = term_getline(b:term_buf, 1)
  let path = a:1.'/'.path
  if filereadable(path)
    exe 'edit ' . path
  else
    close
  endif
endfunction

nnoremap <expr> <c-p> <SID>Open()
hi Terminal guibg=#3c4151 guifg=#dfe2e2
