function find#findWord (word)
  let flagFile = 'package.json'
  let f = '/src/**/*'
  let root = utils#findRoot(flagFile)
  exe "normal /" . a:word . "\<cr>"
  if (root != v:null)
    exe "vim /" . a:word . '/j ' . root . f
  else
    echo "找不到文件:" . flagFile . ", 无法确定搜索目录"
  endif
endfunc
