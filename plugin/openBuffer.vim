function! <SID>Open()
  let root = utils#findRoot('.git')
  let origin_path = getcwd()
  if root == v:null
    let root = utils#findRoot('package.json')
  endif
  if root == v:null
    let root = '.'
  endif
  redir => b:output
  execute('ls')
  redir END
  let b:output = trim(b:output)
  let b:output = split(b:output, '\n')
  let files = map(b:output, 'split(v:val)[-3] . " " . split(v:val)[0]')
  let files = join(b:output, '\n')
  let options = {'cwd': root, 'term_name': 'FZF', 'exit_cb': function('s:OpenBuffer', [root, origin_path]), 'vertical': 1, 'env': { 'FZF_DEFAULT_COMMAND': 'echo "' . files . '"' } }
  try 
    let b:term_buf = term_start("fzf", options)
  catch /.*/
    echom 'errrrr'
  endtry
endfunction

function s:OpenBuffer(...)
  let result = split(term_getline(b:term_buf, 1), ' ')
  if len(result) == 2
    let num = result[-1]
    execute('b ' . num)
  else
    exit
  endif
endfunction

nnoremap <expr> <c-b> <SID>Open()
