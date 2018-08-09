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
  let search = input#input("请输入查找的单词")
  let root = utils#findRoot(flagFile)
  if (root != v:null)
    exe "vim /" . search . '/ ' . root . f
  else
    echo "找不到文件:" . flagFile . ", 无法确定搜索目录"
  endif
endfunc
