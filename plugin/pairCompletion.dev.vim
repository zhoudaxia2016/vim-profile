"let pairs = ["''", '""', "()", "[]", "{}"]
"for pair in pairs
"  exec "inoremap " . pair[0] . "<c-r>=BeginPair(" . pair . ")<cr>"
"  exec "inoremap " . pair[1] . "<c-r>=SkipPair(" . pair . ")<cr>"
"endfor
"
"function BeginPair(pair)
"  let b:in_pair = 1
"  if pair[0] == '{'
"    return "{<CR>}<ESC>O"
"  else
"    return join(pair, '') . "\<esc>O"
"  endif
"endfunc
"
""设置跳出自动补全的括号
"func SkipPair(pair)
"  if exists(b:in_pair)
"    unlet b:in_pair
"    return "\<ESC>la"
"  else
"    return pair[1]
"  endif
"endfunc
