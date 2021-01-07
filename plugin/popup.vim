let popup_commonMenus = []

" 复制全部
function s:copyAll()
  :%y
  call s:copy()
endfunc

" 复制剪贴板
function s:copy()
  call system('clip.exe', substitute(@0, '\n$', '', ''))
endfunc

" 运行当前文件
let s:runCommands = #{javascript: '!node %', vim: 'source %'}
function s:runCode()
  let command = get(s:runCommands, &filetype, v:null)
  if command != v:null
    execute(command)
  endif
endfunc

" 转换unicode成中文
function s:unicode2chinese()
  %s/\(\\u\x\+\)\+/\=eval('"'.submatch(0).'"')/g
endfunc

function s:format()
  .s/\(:\|,\)/\1 /g
endfunc

call add(popup_commonMenus, #{text: '复制vim剪贴板内容到系统剪贴板', action: function('s:copy')})
call add(popup_commonMenus, #{text: '复制所有内容到系统剪贴板', action: function('s:copyAll')})
call add(popup_commonMenus, #{text: '运行', action: function('s:runCode')})
call add(popup_commonMenus, #{text: '转换unicode成中文', action: function('s:unicode2chinese')})
call add(popup_commonMenus, #{text: '格式化', action: function('s:format')})

nnoremap <silent> <leader>o :call popup#menu(popup_commonMenus)<cr>
