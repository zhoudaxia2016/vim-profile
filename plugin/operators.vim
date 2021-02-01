func s:getRange ()
  let start = line("'['")
  let end = line("']'")
  return [start, end]
endfunc

func s:init ()
  let ft = expand('<amatch>')
  let filetype_exclude = ['netrw', 'help']

  " comment operator
  
  " execute operator
endfunc
au FileType * call s:init()

" 注释
func s:comment (type, ...)
  let [start, end] = s:getRange()
  for line in range(start, end)
    if match(getline(line), b:comment_str) != 0
      exe line . 's/^\|^' . b:comment_str . '/' . b:comment_str . ' '
    endif
  endfor
endfunc

" 执行vim代码
func s:execute (type, ...)
  let reg_save = @@
  exe "normal '[V']y"
  exe @@
  let @@ = reg_save
endfunc

" 命名case
func s:toggleNameCase (type, ...)
  let reg_save = @@
  exe "normal `[v`]y"
  let name = @@
  let list = split(name, '_\|-\|\u\@=')
  let case = input#radio('cases', ['camelCase', 'PascalCase', 'snake_case', 'kebab-case'])
  if case == 1
    let list[1:] = map(list[1:], 'toupper(v:val[0]).v:val[1:]')
    let list[0] = tolower(list[0])
  elseif case == 2
    let list = map(list, 'toupper(v:val[0]).v:val[1:]')
  elseif case == 3
    let list = map(list, 'tolower(v:val)')
    let list[1:] = map(list[1:], '"_".v:val')
  elseif case == 4
    let list = map(list, 'tolower(v:val)')
    let list[1:] = map(list[1:], '"-".v:val')
  endif
  exe "normal `<v`>c" . join(list, '')
  let @@ = reg_save
endfunc

" copy to system clipboard
func s:sysCopy (type, ...)
  let reg_save = @@
  exe "normal `[v`]y"
  let name = @@
  call system(s:clipCommand . " " . name)
endfunc

" find word
func s:findWord (type, ...)
  let reg_save = @@
  exe "normal `[v`]y"
  let word = @@
  call find#findWord(word)
endfunc
