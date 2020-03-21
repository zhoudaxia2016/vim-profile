function Sub(pattern, replace)
  let beginDeli = '{#'
  let endDeli = '#}'
  exec '%s/' . beginDeli . '\s*' . a:pattern .  '\s*' . endDeli . '/' . beginDeli . a:replace . endDeli . '/g'
endfunc

function Smarty2art()
  call Sub('elseif\(.*\)', 'else if\1')
  call Sub('assign\s\+var="\?\(\w\+\)"\?\s\+value=\(\S\+\)', 'set $\1 = \2')
  call Sub('foreach\s\+from=\(\S\+\)\s\+item=\(\w\+\)\s\+key=\(\w\+\)', 'each \1 $\2 $\3')
  call Sub('foreach\s\+from=\(\S\+\)\s\+item=\(\w\+\)', 'each \1 $\2')
  call Sub('foreach\s\+from=\(\S\+\)\s\+key=\(\w\+\)', 'each \1 $\2')
  call Sub('foreach\s\+from=\(\S\+\)', 'each \1')
  call Sub('\/foreach', '\/each')
  call Sub('#\(\w\+\)#', '\1')
  call Sub('\(.*\)|@\(.*\)', '\1|\2')
  call Sub('include\s\+file="\?\([^"#]\+\)"\?', 'include("\1")')
  :%s/{#\*\(.*\)\*#}/<!--\1-->/
  :%s/\({#.*\)\@<=\<eq\>\(.*#}\)\@=/==/g
  :%s/\({#.*\)\@<=\<neq\>\(.*#}\)\@=/!=/g
  :%s/\({#.*\)\@<=\<and\>\(.*#}\)\@=/\&\&/g
endfunc

"nnoremap q :q!<cr>
set foldlevel=10
"au BufEnter *.html call Smarty2art()
"au BufEnter *.tpl call Smarty2art()
