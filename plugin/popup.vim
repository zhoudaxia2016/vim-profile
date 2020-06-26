let popup_commonMenus = []

function s:copyAll()
  :%y
  call s:copy()
endfunc

function s:copy()
  call system('clip.exe', substitute(@0, '\n$', '', ''))
endfunc

call add(popup_commonMenus, #{text: '复制vim剪贴板内容到系统剪贴板', action: function('s:copy')})
call add(popup_commonMenus, #{text: '复制所有内容到系统剪贴板', action: function('s:copyAll')})

nnoremap <silent> <leader>o :call popup#menu(popup_commonMenus)<cr>
