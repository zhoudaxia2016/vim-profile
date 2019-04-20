func s:getRange ()
  let start = line("'['")
  let end = line("']'")
  return [start, end]
endfunc

" 注释
func s:comment (type, ...)
  let config = utils#readConfig(expand('$HOME/.vim/yamls/comment-operator.yaml'))
  let commentStr = get(config, expand('%:e'), '//')
  let commentStr = substitute(commentStr, '/', '\\/', 'g')
  let [start, end] = s:getRange()
  for line in range(start, end)
    if match(getline(line), commentStr) != 0
      exe line . 's/^\|^' . commentStr . '/' . commentStr . ' '
    endif
  endfor
endfunc
call operator#new("<tab>m", function('s:comment'))

" 执行vim代码
func s:execute (type, ...)
  let reg_save = @@
  exe "normal '[V']y"
  exe @@
  let @@ = reg_save
endfunc
call operator#new("<tab>e", function('s:execute'))
