let popup_commonMenus = []
call add(popup_commonMenus, #{text: 'Copy vim clipboard to system clipboard', action: 'call system("clip.exe", @0)'})
call add(popup_commonMenus, #{text: 'Copy whole file to system clipboard', action: '%y" | call system("clip.exe", @0)'})

nnoremap <leader>o :call popup#menu(popup_commonMenus)<cr>
