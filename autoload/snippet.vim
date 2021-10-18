vim9script
const snippetDir = $HOME .. '/.vim/snippets/'
const snippetPlaceholderPattern = '\${[^}]\+}'
const propPlaceholder = 'snippet-placeholder'
var isSnippetJump = 0
var id = 0

def SnippetGuid(): number
  id = id + 1
  return id
enddef

def snippet#LoadSnippet()
  if exists('b:loadSnippetPlugin')
    return
  endif
  b:loadSnippetPlugin = 1
  var key = ''
  var snippets = {}
  var snippetFileIndent = '  '
  var fn = snippetDir .. &filetype .. '.snip'
  if !filereadable(fn)
    return
  endif
  for line in readfile(fn)
    if line =~ '^snippet'
      key = split(line, ' ')[1]
      if has_key(snippets, key)
        throw 'Duplicate Snippet Key!'
        return
      endif
    elseif line =~ '^\s\+'
      if has_key(snippets, key)
        add(snippets[key], substitute(line, '^' .. snippetFileIndent, '', ''))
      else
        snippets[key] = [substitute(line, '^' .. snippetFileIndent, '', '')]
      endif
    endif
  endfor
  b:snippets = snippets
enddef

def snippet#ExpandSnippet(default: string): string
  var start = col('.') - 1
  var line = getline('.')
  while start > 0 && line[start - 1] !~ '\s'
    start -= 1
  endwhile
  var currentIndent = repeat(' ', indent('.'))
  var trigger = line[start : ]
  if exists('b:snippets') && has_key(b:snippets, trigger)
    var snippet = mapnew(b:snippets[trigger], (_, l) => currentIndent .. l)
    var lines: list<string>
    [lines, snippet] = GenerateSnippetInfo(snippet)
    append('.', lines)
    normal dd
    AddSnippetJumpList(snippet)
    placeholderIndex = 0
    return g:JumpSnippet(snippet)
  endif
  return default
enddef

def GenerateSnippetInfo(snippet: list<string>): list<any>
  const pat = '\${\(\d\+\)\(:\([^}]\+\)\)\?}'
  const patVar = '\$\(\d\+\)'
  var info = {}
  var lines = []
  var lineIndex = 0
  for line in snippet
    var newLine = ''
    while 1
      var a = matchstrpos(line, snippetPlaceholderPattern)
      if (a[0] == '')
        break
      endif
      var m = matchlist(a[0], pat)
      var i = m[1]
      var default = m[3] == '' ? '_' : m[3]
      info[i] = {
        line: lineIndex,
        startCol: a[1],
        default: default,
        id: SnippetGuid()
      }
      newLine = substitute(line, a[0], default, '')
    endwhile
    lineIndex += 1
    add(lines, newLine)
  endfor
  lineIndex = 0
  for line in lines
    var start = 0
    while 1
      var a = matchstrpos(line, patVar, start)
      if (a[0] == '')
        break
      endif
      var m = matchlist(a[0], patVar)
      var placeholder = get(info, m[1], {})
      if !empty(placeholder)
        if !has_key(placeholder, 'variable')
          placeholder.variable = []
        endif
        add(placeholder.variable, { line: lineIndex, startCol: a[1], length: len(a[0]), id: SnippetGuid() })
      endif
      start = a[2]
    endwhile
    lineIndex += 1
  endfor

  return [lines, info]
enddef

def AddSnippetJumpList(snippet: dict<any>)
  var currentLine = line('.')
  var i = 0
  var placeholders = keys(snippet)
  var placeholderCount = len(placeholders)
  for key in placeholders
    var value = snippet[key]
    prop_add(currentLine + value.line, value.startCol + 1, { type: propPlaceholder, length: len(value.default), id: value.id })
    if has_key(value, 'variable')
      for v in value.variable
        prop_add(currentLine + v.line, v.startCol + 1, { type: propPlaceholder, length: v.length, id: v.id })
      endfor
    endif
  endfor
  g:snippet_save_map = maparg('<c-j>', 'i', 0, 1)
  if placeholderCount != 0
    g:snippetPlaceholderCount = placeholderCount
    g:snippet = snippet
    inoremap <c-j> <c-r>=JumpSnippet(snippet)<cr>
  endif
enddef

var placeholderIndex = 0
def SnippetReplaceVariable()
  var snippet = g:snippet
  if placeholderIndex != 1
    var lastValue = snippet[placeholderIndex - 1]
    if has_key(lastValue, 'variable')
      for v in lastValue.variable
        var prop = prop_find({ id: v.id }, 'f')
        if empty(prop)
          prop = prop_find({ id: v.id }, 'b')
        endif
        if !empty(prop)
          var lastInsert = @. == '' ? lastValue.default : @.
          var view = winsaveview()
          exec 'silent keeppatterns :%s/\%' .. prop.lnum .. 'l\%' .. prop.col .. 'c.*\%' .. string(prop.col + prop.length) .. "c/" .. lastInsert .. "/"
          winrestview(view)
        endif
      endfor
    endif
  endif
enddef

def g:JumpSnippet(snippet: dict<any>): string
  placeholderIndex += 1
  var value = snippet[placeholderIndex]
  var prop = prop_find({ id: value.id, skipstart: 1 }, 'f')
  if empty(prop)
    prop = prop_find({ id: value.id, skipstart: 1 }, 'b')
  endif
  if !empty(prop)
    cursor(prop.lnum, prop.col)
    var str: string
    if prop.length <= 1
      str = "v\<c-g>"
    else
      str = "v" .. string(prop.length - 1) .. "l\<c-g>"
    endif
    if prop.col != 1
      str = 'l' .. str
    endif
    isSnippetJump = 1
    timer_start(100, ResetSnippetJump)
    if placeholderIndex >= g:snippetPlaceholderCount
      SnippetReset()
    endif
    return "\<esc>" .. str
  endif
  return ''
enddef

def ResetSnippetJump(_: number)
  isSnippetJump = 0
enddef

def SnippetReset()
  if exists('g:snippet_save_map')
    mapset('i', 0, g:snippet_save_map)
  endif

enddef

def snippet#SnippetHandleInsertLeave()
  if isSnippetJump == 0
    prop_remove({ type: propPlaceholder, all: 1 })
    SnippetReset()
  else
    if placeholderIndex != 0
      SnippetReplaceVariable()
    endif
  endif
enddef
