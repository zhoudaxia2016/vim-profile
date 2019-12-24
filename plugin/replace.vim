nnoremap <leader>r :call <SID>replace()<cr>
nnoremap <leader>f :call <SID>find()<cr>
nnoremap <leader>0 :%s///gn<cr>

function <SID>replace ()
  let search = input#input("请输入查找的单词")
  let sub = input#input("\n请输入替换的单词")
  exe '1,$s/' . search . '/' . sub . '/gc'
endfunc

function <SID>find ()
  let search = input#input("请输入查找的单词")
  call find#findWord(search)
endfunc
