let s:brackets = ["()", "[]", "{}"]
let s:quotations = ['"', "'", "`"]

inoremap <cr> <c-r>=<SID>mapEnter()<cr>

function <SID>mapEnter ()
  let curChar = getline('.')[col('.')-1]
  for b in s:brackets
    if b[1] == curChar
      return "\<cr>\<esc>ko"
    endif
  endfor
  return "\<cr>"
endfunc

au InsertLeave * call <SID>clear()
function <SID>clear()
  if exists('w:quot_stack')
    unlet w:quot_stack
  endif
endfunc

let l = len(s:brackets)
let i = 0
while(i < l)
  exe "inoremap " . s:brackets[i][0] . " <c-r>=BeginBracket(" . i . ")<cr>"
  exe "inoremap " . s:brackets[i][1] . " <c-r>=SkipBracket(" . i . ")<cr>"
  let i = i + 1
endwhile

let l = len(s:quotations)
let i = 0
while(i < l)
  exe "inoremap " . s:quotations[i][0] . " <c-r>=InputQuot(" . i . ")<cr>"
  let i = i + 1
endwhile

function InputQuot (i)
  if exists('w:quot_stack') && len(w:quot_stack) > 0
    if w:quot_stack[-1] == a:i
      call remove(w:quot_stack, -1)
      return "\<right>"
    else
      call add(w:quot_stack, a:i)
      return s:quotations[a:i] . s:quotations[a:i] . "\<left>"
    endif
  else
    let w:quot_stack = []
    call add(w:quot_stack, a:i)
    return s:quotations[a:i] . s:quotations[a:i] . "\<left>"
  endif
endfunc

function BeginBracket (i)
  return s:brackets[a:i] . "\<left>"
endfunc

"设置跳出自动补全的括号
func SkipBracket (i)
  if getline('.')[col('.')-1] == s:brackets[a:i][1]
    return "\<right>"
  else
    return s:brackets[a:i][1]
  endif
endfunc
