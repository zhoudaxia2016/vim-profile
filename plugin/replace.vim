nnoremap <leader>r :call <SID>replace()<cr>
nnoremap <leader>f :call <SID>find()<cr>

function <SID>replace ()
  let search = input#input("请输入查找的单词")
  let sub = input#input("\n请输入替换的单词")
  exe '1,$s/' . search . '/' . sub . '/gc'
endfunc

function <SID>find ()
  let flagFile = 'package.json'
  let f = '*'
  let cur = ''
  let c = 0
  let search = input#input("请输入查找的单词")
  while (c < 10)
    let c += 1
    if (file_readable(cur . flagFile))
      exe "vim /" . search . '/ ' . cur . f
      return feedkeys('<cr>')
    endif
    let cur .= '../'
  endwhile
  echo "找不到文件:" . flagFile . ", 无法确定搜索目录"
endfunc
