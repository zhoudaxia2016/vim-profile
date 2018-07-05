function snippet#triggerSnippet ()
  " snippet开关,当触发snippet时执行

  " 如果已经定义了b:snip_state,则直接进行跳转,否则通过下面新建需要的对象
  if exists('b:snip_state')
    return s:jump(0)
  endif

  " 读取snippet文件,获取对应snippet
  let snippet_dir = $HOME . '/.vim/snippets/'
  let snippets = s:readSnippet(&filetype, snippet_dir)
  let word = s:getWordBelowCursor()
  let snippet = s:getSnippet(word, snippets)
  if len(snippet) == 0 | return '' | endif

  " 删除鼠标下触发snippet的单词
  call s:deleteWordBelowCursor()

  " 保存当前行剩下的内容,下面会与获取的snippet拼接
  let curLineStr = getline('.')

  " 基本变量
  let stoppar = '${\([^}]*\)}'
  let mirrorpar = '$\(\d\+\)'
  let b:stops = []
  let b:mirrors = []
  let lines = []
  let lnum = 0
  let curLine = line('.')
  let stopNum = 0
  " snippet状态变量 num: 当前stop索引 selected: 是否处于选择状态
  let b:snip_state = {"num": -1, "selected": 1}
  " 上次输入的字符
  let b:lastInsetedChar = ''
  " 获取缩进,添加到处理好的snippet
  let indent = indent(curLine)
  let indentStr = repeat(' ', indent)

  " 一轮扫描,获取stops(跳转位置),替换stop
  for line in snippet
    let curStops = []
    call add(lines, substitute(line, stoppar, '\=s:parseStop(submatch(1), curStops)', 'g'))
    let cols = s:getCol(line, stoppar)
    " 当开头与结尾都有stop时,cols长度比curStops长度小1
    " 出现索引错误,给cols在开头插入0即可解决
    if len(cols) < len(curStops)
      call insert(cols, 0, 0)
    endif
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

  " 二轮扫描,获取mirrors(与stops同步的变量位置),这些mirrors还没有根据对应的stop替换
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

  " 三轮扫描,替换mirrors,并计算位置 
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

  " 拼接之前保存的当前行
  let afterLines[0] = curLineStr . afterLines[0]
  let i = 1
  let l = len(afterLines)
  " 拼接indent
  while i < l
    let afterLines[i] = indentStr . afterLines[i]
    let i += 1
  endwhile
  " 插入
  call append('.', afterLines)
  " 使用append会出现多余空行,删除之
  exec "normal dd"

  " 定义事件钩子
  " CursormovedI 每次输入用来更新位置与mirror
  " InsertCharPre 每次输入获取输入字符
  " Cursormoved 离开插入模式时判断是否结束snippet
  aug snippet_change
    au CursormovedI <buffer> if exists('b:snip_state') |
      \ call s:updateChange() |
      \ else |
      \   au! snippet_change * <buffer> |
      \ endif
    au InsertCharPre <buffer> call s:getLastInserted()
    au Cursormoved <buffer> call s:handleCursorMoved()
  aug END

  " 跳到第一个stop
  if !empty(b:stops)
    return s:jump(0)
  endif
  return ''
endfunc

" 获取上次输入字符,因为只有InsertEnter和InsertCharPre钩子
" 才有v:char变量,v:char是该次输入字符
" 并且不能获取<bs>删除键,只能每次操作完
" 将b:lastInsetedChar赋值为空,即是输入<bs>的情况
function s:getLastInserted ()
  let b:lastInsetedChar = v:char
endfunc

" 处理mirror,有两次
" 通过参数数目进行重载
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

" 在select mode跳转会有些不同,所以需要单独处理
function snippet#triggerSnippetAtSelectMode ()
  if exists('b:snip_state')
    exec 'normal ' . s:jump(1)
  endif
endfunc

" 如果不是在为了select word离开insert mode
" 则结束snippet
function s:handleCursorMoved ()
  if !exists('b:in_select_mode')  
    call s:remove()
  endif
  unlet! b:in_select_mode
endfunc

" 跳转
function s:jump (selectMap)
  let next = b:snip_state.num + 1
  " 当next大于等于stops长度时,结束snippet
  if next >= len(b:stops)
    call s:remove()
    return ''
  endif
  " 跳转到下个stop
  call cursor(b:stops[next].lnum, b:stops[next].cols)
  let b:snip_state.num = next
  let b:snip_state.selected = 1
  " 选择该stop的val
  return s:selectWord(b:stops[next].val, a:selectMap)
endfunc

" 结束snippet
function s:remove ()
  unlet b:snip_state
  unlet b:stops
  unlet b:mirrors
  unlet b:lastInsetedChar
  au! snippet_change * <buffer>
endfunc

" 更新mirror后再更新位置
function s:updatePos (lnum, cols, change)
  let mirrors = filter(copy(b:mirrors), 'v:val.lnum == a:lnum && v:val.cols > a:cols')
  for item in mirrors
    let item.cols += a:change
    let item.colsEnd += a:change
  endfor
  let stops = filter(copy(b:stops), 'v:val.lnum == a:lnum && v:val.cols > a:cols')
  for item in stops
    let item.cols += a:change
  endfor
endfunc

" 更新mirror
function s:updateMirror (mirror, change)
  let pos = getpos('.')
  let lnum = a:mirror.lnum
  let cols = a:mirror.cols
  " 当处于选择状态时,替换默认值
  if b:snip_state.selected
    call cursor(lnum, cols)
    let l = a:mirror.colsEnd - cols + 1
    exec "normal " . (l == 0 ? 'r' : 'c' . l . 'l') . b:lastInsetedChar
  else
    call cursor(lnum, a:mirror.colsEnd)
    exec "normal " . (b:lastInsetedChar == '' ? 'x' : 'a' . b:lastInsetedChar)
  endif
  let a:mirror.colsEnd += a:change
  call s:updatePos(lnum, cols, a:change)
  call setpos('.', pos)
endfunc

" 处理输入换行的情况
function s:handleNewLine ()
  let num = b:snip_state.num
  let lnum = b:stops[num].lnum
  let cols = b:stops[num].cols
  let indent = indent('.')

  let stops1 = filter(copy(b:stops), 'v:val.lnum == lnum && v:val.cols > cols')
  let stops2 = filter(copy(b:stops), 'v:val.lnum > lnum')
  let mirrors1 = filter(copy(b:mirrors), 'v:val.lnum == lnum && v:val.cols > cols')
  let mirrors2 = filter(copy(b:mirrors), 'v:val.lnum > lnum')

  let b:stops[num].lnum += 1
  let b:stops[num].cols = indent

  for item in stops1
    let item.lnum += 1
    let item.cols = indent + item.cols - cols
  endfor

  for item in stops2
    let item.lnum += 1
  endfor

  for item in mirrors1
    let item.lnum += 1
    let item.cols = indent + item.cols - cols
    let item.colsEnd = indent + item.colsEnd - cols
  endfor

  for item in mirrors2
    let item.lnum += 1
  endfor
  echom string(b:stops)
endfunc

" 更新位置和mirror
function s:updateChange ()
  let num = b:snip_state.num
  let stopLen = len(b:stops)
  echom 'aa'
  if num >= stopLen
    call s:remove()
    return
  endif
  let lnum = getpos('.')[1]
  if lnum > b:stops[num].lnum
    call s:handleNewLine()
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

  call s:updatePos(stop.lnum, stop.cols, change)

  let mirrors = filter(copy(b:mirrors), 'v:val.stopNum == b:snip_state.num')
  for item in mirrors
    call s:updateMirror(item, change)
  endfor
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

function s:parseStop (val, stops)
  call add(a:stops, { 'val': a:val })
  return a:val
endfunc

" 获取触发snippet的单词
function s:getWordBelowCursor ()
  return matchstr(getline('.'), '\S\+\%' . col('.') . 'c')
endfunc

" 选择默认值
function s:selectWord (word, selectMap)
  let b:in_select_mode = 1
  let len = len(a:word)
  if b:snip_state.num == len(b:stops) - 1
    call s:remove()
  endif
  if a:selectMap == 0
    let l = col('.') == 1 ? '' : 'l'
    return len == 1 ? "\<esc>" . l . 'gh' : "\<esc>" . l . "v" . (len-1) . "l\<c-g>"
  else
    return len == 1 ? 'gh' : 'v' . (len-1) . "l\<c-g>"
  endif
endfunc

function s:readSnippetFile (ft, dir)
  let snippets = get(g:snippet_cache, a:ft, 0)
  if type(snippets) == type([])
    return snippets
  endif
  let fn = a:dir . a:ft . '.snippet'
  if !filereadable(fn) | return [] | endif
  let snippets = []
  for line in readfile(fn)
    if line[:6] == 'snippet'
      let trigger = strpart(line, 8)
      call add(snippets, { 'trigger': trigger, 'snippet': [] })
    else
      if line != ''
	call add(snippets[-1].snippet, line)
      endif
    endif
  endfor
  let g:snippet_cache[a:ft] = snippets
  return snippets
endfunc

" 读取snippet文件
function s:readSnippet (ft, dir)
  let fts = get(g:snippet_filetypes, a:ft, a:ft)
  if type(fts) == type('')
    return s:readSnippetFile(fts, a:dir)
  endif
  let snippets = []
  for ft in fts
    let snippets += s:readSnippetFile(ft, a:dir)
  endfor
  return snippets
endfunc

" 选择snippet
function s:getSnippet (word, snippets)
  for item in a:snippets
    if a:word == item.trigger
      return item.snippet
    endif
  endfor
  return ''
endfunc

" 删除光标下的触发snippet的单词
function s:deleteWordBelowCursor ()
  let line = getline('.')
  let line =  substitute(line, '\S\+\%' . col('.') . 'c', '', '')
  call setline(line('.'), line)
endfunc
