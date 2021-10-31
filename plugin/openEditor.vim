function s:onError(id, data, name)
  echom a:data
endfunc
let serverFile = expand('<sfile>:h') . '/../tools/server/main.js'

command InitServer call jobstart('node ' . serverFile . ' ' . serverlist()[0], { 'on_stderr': function('s:onError') })
