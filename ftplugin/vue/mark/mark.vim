let json = json#readfile("pos.json")
for [key, value] in items(json)
  exe "normal " . value . "\<cr>" 
  exe "normal m" . key
  echom "normal " . value . "\<cr>" 
  echom "normal m" . key
  exe "normal ``"
endf
