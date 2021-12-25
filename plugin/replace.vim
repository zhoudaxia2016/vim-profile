nnoremap <leader>r :call <SID>replace()<cr>

function <SID>replace ()
  let search = input#input("请输入查找的单词")
  let sub = input#input("\n请输入替换的单词")
  exe '1,$s/' . search . '/' . sub . '/gc'
endfunc
