nnoremap <leader>w :call <SID>gitCmd()<cr>

function <SID>gitCmd ()
  let flagDir = ".git"
  let root = utils#findRoot(flagDir)
  if root == v:null
    echo "找不到目录: " . flagDir . ", 无法确定git项目"
    return
  endif

  let cmds = [
    \   "git add " . root,
    \   "git commit -a -m",
    \   "git push"] 
  let sel = input#radio("你想使用的git命令是", cmds)
  echom '!' . cmds[sel-1]
  exe '!' . cmds[sel-1]
endfunc
