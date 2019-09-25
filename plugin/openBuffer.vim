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
  redir => b:ouput
  execute('ls')
  redir END
  let b:term_buf = term_start('echo ' . b:ouput . ' | fzf', options)
endfunction

function s:OpenFile(...)
  let path = term_getline(b:term_buf, 1)
  echo path
endfunction

nnoremap <expr> <c-b> <SID>Open()
