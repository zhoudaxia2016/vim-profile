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
  let stoppar = '${\(\d\+\):\([^}]\+\)}'
  let mirrorpar = '$\(\d\+\)'
  let b:stops = []
  let b:mirrors = []
  let lines = []
  let lnum = 0
  let curLine = line('.')
  let stopNum = 0
  let b:snip_state = {"num": -1, "selected": 1 }
  inoremap <bs> <c-r>=<SID>deleteChar()<cr>

  for line in snippet
    let curStops = []
    call add(lines, substitute(line, stoppar, '\=s:parse(submatch(1), submatch(2), curStops)', 'g'))
    let cols = s:getCol(line, stoppar)
    let beforeStopLen = 0
    let i = 0
    for item in curStops
      let item.lnum = lnum + curLine
      let item.cols = cols[i] + beforeStopLen + 1
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
    call add(afterLines, substitute(line, mirrorpar, '\=s:parseMirror(submatch(1), curMirrors)', 'g'))
    let cols = s:getCol(line, mirrorpar)
    let beforeMirrorLen = 0
    let i = 0
    for item in curMirrors
      let item.lnum = lnum + curLine
      let item.cols = cols[i] + beforeMirrorLen + 1
      let i += 1
      call add(b:mirrors, item)
      let beforeMirrorLen = beforeMirrorLen + len(b:stops[item.stopNum])
    endfor
    let lnum = lnum + 1
  endfor

  call append(line('.') - 1, afterLines)

  aug snippet_change
    au CursormovedI <buffer> if exists('b:snip_state') |
      \ call s:updateChange() |
      \ else |
      \   au! snippet_change * <buffer> |
      \ endif
    au Cursormoved <buffer> call s:handleCursorMoved()
  aug END

  if !empty(b:stops)
    return s:jump(0)
  endif
  return ''
endfunc

function <SID>deleteChar ()
  let b:input_back_space = 1
  return "\<bs>"
endfunc

function s:parseMirror (stopNum, mirrors)
  call add(a:mirrors, { 'stopNum': a:stopNum })
  echom b:stops[a:stopNum].val
  return b:stops[a:stopNum].val
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
  au! snippet_change * <buffer>
endfunc

function s:updateChange ()
  let num = b:snip_state.num
  let stopLen = len(b:stops)
  if num >= stopLen
    call remove()
    return
  endif
  let stop = b:stops[num]
  let lnum = stop.lnum
  if b:snip_state.selected == 1
    let change = 1 - len(stop.val)
    let b:snip_state.selected = 0
  else
    if exists('b:input_back_space')
      let change = -1
      unlet b:input_back_space
    else
      let change = 1
    endif
  endif
  while num < stopLen
    let nextStop = b:stops[num]
    if lnum != nextStop.lnum
      break
    endif
    let nextStop.cols = nextStop.cols + change
    let num = num + 1
  endwhile
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
    echom len == 1 ? 'gh' : 'v' . (len-1) . "l\<c-g>"
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
