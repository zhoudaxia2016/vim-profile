let s:brackets = ["()", "[]", "{}"]
let s:quotations = ['"', "'", "`"]

au FileType * call s:modifyConfig()
function s:modifyConfig ()
  let ft = expand('<amatch>')
  if ft == 'netrw' 
    return
  end
  if ft == 'vim'
    let b:quotations = ["'", "`"]
  else
    let b:quotations = s:quotations
  endif
  inoremap <cr> <c-r>=<SID>mapEnter()<cr>
  let l = len(s:brackets)
  let i = 0
  while(i < l)
    exe "inoremap " . s:brackets[i][0] . " <c-r>=BeginBracket(" . i . ")<cr>"
    exe "inoremap " . s:brackets[i][1] . " <c-r>=SkipBracket(" . i . ")<cr>"
    let i = i + 1
  endwhile

  let l = len(b:quotations)
  let i = 0
  while(i < l)
    exe "inoremap <buffer> " . b:quotations[i][0] . " <c-r>=InputQuot(" . i . ")<cr>"
    let i = i + 1
  endwhile
endfunc

function <SID>mapEnter ()
  let curChar = getline('.')[col('.')-1]
  for b in s:brackets
    if b[1] == curChar
      return "\<cr>\<esc>ko"
    endif
  endfor
  return "\<cr>"
endfunc

function InputQuot (i)
  let curline = getline('.')
  let column = col('.')
  let currentChar = curline[column - 1]
  let lastChar = curline[column - 2]
  if currentChar == b:quotations[a:i]
    return "\<right>"
  elseif currentChar =~ '\S' || lastChar =~ '\S'
    return b:quotations[a:i]
  else
    return b:quotations[a:i] . b:quotations[a:i] . "\<left>"
  endif
endfunc

function BeginBracket (i)
  let char = getline('.')[col('.') - 1]
  if char =~ '[[:keyword:]]'
    return s:brackets[a:i][0]
  else
    return s:brackets[a:i] . "\<left>"
  endif
endfunc
"设置跳出自动补全的括号
func SkipBracket (i)
  if getline('.')[col('.')-1] == s:brackets[a:i][1]
    return "\<right>"
  else
    return s:brackets[a:i][1]
  endif
endfunc
