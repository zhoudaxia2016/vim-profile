function snippet#triggerSnippet ()
  if exists('b:snip_state')
    return s:jump(0)
  endif
  let fn = $HOME .'/.vim/snippets/javascript.snippet'
  let snippets = s:readSnippet(fn)
  let word = s:getWordBelowCursor()
  let snippet = s:getSnippet(word, snippets)
  if len(snippet) == 0 | return '' | endif
  call s:deleteWordBelowCursor()
  let curLineStr = getline('.')
  let stoppar = '${\(\d\+\):\([^}]\+\)}'
  let mirrorpar = '$\(\d\+\)'
  let b:stops = []
  let b:mirrors = []
  let lines = []
  let lnum = 0
  let curLine = line('.')
  let stopNum = 0
  let b:snip_state = {"num": -1, "selected": 1}
  let b:lastInsetedChar = ''
  let indent = indent(curLine)
  let indentStr = repeat(' ', indent)

  for line in snippet
    let curStops = []
    call add(lines, substitute(line, stoppar, '\=s:parse(submatch(1), submatch(2), curStops)', 'g'))
    let cols = s:getCol(line, stoppar)
    let beforeStopLen = 0
    let i = 0
    for item in curStops
      let item.lnum = lnum + curLine
      let item.cols = cols[i] + beforeStopLen + 1 + indent
      let i += 1
      call add(b:stops, item) 
      let beforeStopLen = beforeStopLen + len(item.val)
    endfor
    let lnum = lnum + 1
  endfor

  let afterLines = []
  let lnum = 0
  for line in lines
    let curMirrors = []
    call substitute(line, mirrorpar, '\=s:parseMirror(submatch(1), submatch(0), curMirrors)', 'g')
    let cols = s:getCol(line, mirrorpar)
    let i = 0
    for item in curMirrors
      let l = len(b:stops[item.stopNum])
      let item.lnum = lnum + curLine
      let item.cols = cols[i] + i*2 + 1 + indent
      let i += 1
      call add(b:mirrors, item)
    endfor
    let lnum = lnum + 1
  endfor

  let lnum = 0
  for line in lines
    let curMirrors = filter(copy(b:mirrors), 'v:val.lnum == lnum + curLine')
    call add(afterLines, substitute(line, mirrorpar, '\=s:parseMirror(submatch(1))', 'g'))
    let change = 0
    for item in curMirrors
      let l = len(b:stops[item.stopNum].val)
      let item.cols += change
      let curChange = l - 2
      let change += curChange
      let item.colsEnd = item.cols + l - 1
      let stops = filter(copy(b:stops), 'v:val.lnum == lnum + curLine && v:val.cols > item.cols')
      for stop in stops
	let stop.cols += curChange
      endfor
    endfor
    let lnum += 1
  endfor

  let afterLines[0] = curLineStr . afterLines[0]
  let i = 1
  let l = len(afterLines)
  while i < l
    let afterLines[i] = indentStr . afterLines[i]
    let i += 1
  endwhile
  call append('.', afterLines)
  exec "normal dd"

  aug snippet_change
    au CursormovedI <buffer> if exists('b:snip_state') |
      \ call s:updateChange() |
      \ else |
      \   au! snippet_change * <buffer> |
      \ endif
    au InsertCharPre <buffer> call s:getLastInserted()
    au Cursormoved <buffer> call s:handleCursorMoved()
  aug END

  if !empty(b:stops)
    return s:jump(0)
  endif
  return ''
endfunc

function s:getLastInserted ()
  let b:lastInsetedChar = v:char
endfunc

function s:parseMirror (...)
  " Parse first time
  " Add stopNum
  " return $d
  if a:0 == 3
    call add(a:3, { 'stopNum': a:1 })
    return a:2
  " Parse second time
  " return corresponding stop value
  elseif a:0 == 1
    return b:stops[a:1].val
  endif
endfunc

function snippet#triggerSnippetAtSelectMode ()
  if exists('b:snip_state')
    exec 'normal ' . s:jump(1)
  endif
endfunc

function s:handleCursorMoved ()
  if !exists('b:in_select_mode')  
    call s:remove()
  endif
  unlet! b:in_select_mode
endfunc

function s:jump (selectMap)
  let next = b:snip_state.num + 1
  if next >= len(b:stops)
    call s:remove()
    return ''
  endif
  call cursor(b:stops[next].lnum, b:stops[next].cols)
  let b:snip_state.num = next
  let b:snip_state.selected = 1
  return s:selectWord(b:stops[next].val, a:selectMap)
endfunc

function s:remove ()
  unlet b:snip_state
  unlet b:stops
  unlet b:mirrors
  unlet b:lastInsetedChar
  au! snippet_change * <buffer>
endfunc

function s:updateMirror (lnum, cols, change)
  let mirrors = filter(copy(b:mirrors), 'v:val.lnum == a:lnum && v:val.cols > a:cols')
  for item in mirrors
    let item.cols += a:change
    let item.colsEnd += a:change
  endfor
endfunc

function s:updateStop (lnum, cols, change)
  let stops = filter(copy(b:stops), 'v:val.lnum == a:lnum && v:val.cols > a:cols')
  for item in stops
    let item.cols += a:change
  endfor
endfunc

function s:replaceMirror (mirror, change)
  let pos = getpos('.')
  let lnum = a:mirror.lnum
  let cols = a:mirror.cols
  call cursor(lnum, cols)
  let l = a:mirror.colsEnd - cols + 1
  exec "normal " . (l == 0 ? 'r' : 'c' . l . 'l') . b:lastInsetedChar
  let a:mirror.colsEnd = a:mirror.cols
  call s:updateMirror(lnum, cols, a:change)
  call s:updateStop(lnum, cols, a:change)
  call setpos('.', pos)
endfunc

function s:modifyMirror (mirror, change)
  let pos = getpos('.')
  let lnum = a:mirror.lnum
  let cols = a:mirror.cols
  call cursor(lnum, a:mirror.colsEnd)
  exec "normal " . (b:lastInsetedChar == '' ? 'x' : 'a' . b:lastInsetedChar)
  let a:mirror.colsEnd += a:change
  call s:updateMirror(lnum, cols, a:change)
  call s:updateStop(lnum, cols, a:change)
  call setpos('.', pos)
endfunc

function s:updateChange ()
  echom '-----------'
  let num = b:snip_state.num
  let stopLen = len(b:stops)
  if num >= stopLen
    call s:remove()
    return
  endif
  let stop = b:stops[num]
  let lnum = stop.lnum
  if b:snip_state.selected == 1
    let change = 1 - len(stop.val)
  else
    if b:lastInsetedChar == ""
      let change = -1
    else
      let change = 1
    endif
  endif

  call s:updateMirror(stop.lnum, stop.cols, change)
  call s:updateStop(stop.lnum, stop.cols, change)

  let mirrors = filter(copy(b:mirrors), 'v:val.stopNum == b:snip_state.num')
  if b:snip_state.selected
    for item in mirrors
      call s:replaceMirror(item, change)
    endfor
  else
    for item in mirrors
      call s:modifyMirror(item, change)
    endfor
  endif
  let b:snip_state.selected = 0
  let b:lastInsetedChar = ''
endfunc

function s:getCol (line, stoppar)
  let splits = split(a:line, a:stoppar)
  let cols = map(splits, {key, val -> len(val)})
  let i = 1
  let l = len(cols)
  while(i < l)
    let cols[i] = cols[i-1] + cols[i]
    let i = i + 1
  endwhile
  return cols
endfunc

function s:parse (ind, val, stops)
  call add(a:stops, { 'val': a:val })
  return a:val
endfunc

function s:getWordBelowCursor ()
  return matchstr(getline('.'), '\S\+\%' . col('.') . 'c')
endfunc

function s:selectWord (word, selectMap)
  let b:in_select_mode = 1
  let len = len(a:word)
  if a:selectMap == 0
    let l = col('.') == 1 ? '' : 'l'
    return len == 1 ? "\<esc>" . l . 'gh' : "\<esc>" . l . "v" . (len-1) . "l\<c-g>"
  else
    return len == 1 ? 'gh' : 'v' . (len-1) . "l\<c-g>"
  endif
endfunc

function s:readSnippet (fn)
  if !filereadable(a:fn) | return | endif
  let snippets = []
  for line in readfile(a:fn)
    if line[:6] == 'snippet'
      let trigger = strpart(line, 8)
      call add(snippets, { 'trigger': trigger, 'snippet': [] })
    else
      if line != ''
	call add(snippets[-1].snippet, line)
      endif
    endif
  endfor
  return snippets
endfunc

function s:getSnippet (word, snippets)
  for item in a:snippets
    if a:word == item.trigger
      return item.snippet
    endif
  endfor
  return ''
endfunc

function s:deleteWordBelowCursor ()
  let line = getline('.')
  let line =  substitute(line, '\S\+\%' . col('.') . 'c', '', '')
  call setline(line('.'), line)
endfunc
