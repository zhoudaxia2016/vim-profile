function snippet#triggerSnippet ()
  if exists('b:snip_state')
    return s:jump()
  endif
  let fn = $HOME .'/.vim/snippets/javascript.snippet'
  let snippets = s:readSnippet(fn)
  let word = s:getWordBelowCursor()
  let snippet = s:getSnippet(word, snippets)
  if len(snippet) == 0 | return '' | endif
  call s:deleteWordBelowCursor()
  let stoppar = '${\(\d\+\):\([^}]\+\)}'
  let b:stops = {}
  let lines = []
  let lnum = 0
  let curLine = line('.')
  let stopNum = 0
  let b:snip_state = { "stopLen": 0, "num": -1, "selected": 1 }
  for line in snippet
    let curStops = {}
    call add(lines, substitute(line, stoppar, '\=s:parse(submatch(1), submatch(2), curStops)', 'g'))
    let cols = s:getCol(line, stoppar)
    let i = 0
    let beforeStopLen = 0
    for [ind, item] in items(curStops)
      let b:snip_state.stopLen = b:snip_state.stopLen + 1
      let item.lnum = lnum + curLine
      let item.cols = cols[i] + beforeStopLen + 1
      let b:stops[ind] = item 
      let i = i + 1
      let beforeStopLen = beforeStopLen + len(item.val)
    endfor
    let lnum = lnum + 1
  endfor
  call append(line('.') - 1, lines)

  aug snippet_change
    au CursormovedI <buffer> if exists('b:snip_state') |
      \ call s:updateChange() |
      \ else |
      \   au! snippet_change * <buffer> |
      \ endif
    au InsertLeave <buffer> echom 'aaa'
  aug END

  if has_key(b:stops, '0')
    return s:jump()
  endif
  return ''
endfunc

function s:jump ()
  let next = b:snip_state.num + 1
  if next >= b:snip_state.stopLen
    call remove()
    return
  endif
  call cursor(b:stops[next].lnum, b:stops[next].cols)
  let b:snip_state.num = next
  return s:selectWord(b:stops[next].val)
endfunc

function s:remove ()
  unlet b:snip_state
  unlet b:stops
endfunc

function s:updateChange ()
  let num = b:snip_state.num
  let stopLen = b:snip_state.stopLen
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
    let change = 1
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
  let a:stops[a:ind] = { 'val': a:val }
  return a:val
endfunc

function s:getWordBelowCursor ()
  return matchstr(getline('.'), '\S\+\%' . col('.') . 'c')
endfunc

function s:selectWord (word)
  let len = len(a:word)
  let l = col('.') == 1 ? '' : 'l'
  echom "\<esc>" . l . "v" . (len-1) . "l\<c-g>"
  return len == 1 ? "\<esc>" . l . 'gh' : "\<esc>" . l . "v" . (len-1) . "l\<c-g>"
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
