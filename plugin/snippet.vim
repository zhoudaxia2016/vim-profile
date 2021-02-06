vim9script
const snippetFn = $HOME .. '/.vim/snippets/javascript.snip'
const snippetPlaceholderPattern = '\${[^}]\+}'
const propPlaceholder = 'snippet-placeholder'
const propPlaceholderColor = '#e9c496'
var isSnippetJump = 0

def LoadSnippet()
  if exists('g:loadSnippetPlugin')
    return
  endif
  g:loadSnippetPlugin = 1
  var key = ''
  var snippets = {}
  var snippetFileIndent = '  '
  for line in readfile(snippetFn)
    if line =~ '^snippet'
      key = split(line, ' ')[1]
    elseif line =~ '^\s\+'
      if has_key(snippets, key)
        add(snippets[key], substitute(line, '^' .. snippetFileIndent, '', ''))
      else
        snippets[key] = [substitute(line, '^' .. snippetFileIndent, '', '')]
      endif
    endif
  endfor
  g:snippets = snippets
  exec 'hi snippet guifg=' .. propPlaceholderColor
  prop_type_add(propPlaceholder, {highlight: 'snippet'})
enddef

def g:ExpandSnippet():string
  var start = col('.') - 1
  var line = getline('.')
  while start > 0 && line[start - 1] !~ '\s'
    start -= 1
  endwhile
  var currentIndent = repeat(' ', indent('.'))
  var trigger = line[start : ]
  if has_key(g:snippets, trigger)
    var snippet = mapnew(g:snippets[trigger], (_, line) => currentIndent .. line)
    var lines: list<string>
    [lines, snippet] = GenerateSnippetInfo(snippet)
    append('.', lines)
    normal dd
    AddSnippetJumpList(snippet)
    id = 0
    return g:JumpSnippet()
  endif
  return ''
enddef

def GenerateSnippetInfo(snippet: list<string>): list<any>
  const pat = '\${\(\d\+\)\(:\([^}]\+\)\)\?}'
  var info = {}
  var lines = []
  var lineIndex = 0
  for line in snippet
    while 1
      var _ = matchstrpos(line, snippetPlaceholderPattern)
      if (_[0] == '')
        break
      endif
      var m = matchlist(_[0], pat)
      var _id = m[1]
      var default = m[3] == '' ? '_' : m[3]
      info[_id] = {
        line: lineIndex,
        startCol: _[1],
        default: default
      }
      line = substitute(line, _[0], default, '')
    endwhile
    lineIndex += 1
    add(lines, line)
  endfor
  return [lines, info]
enddef

def AddSnippetJumpList(snippet: dict<any>)
  var currentLine = line('.')
  var i = 0
  var ids = keys(snippet)
  var placeholderCount = len(ids)
  for key in ids
    var value = snippet[key]
    prop_add(currentLine + value.line, value.startCol + 1, { type: propPlaceholder, length: len(value.default), id: str2nr(key) })
  endfor
  g:snippet_save_map = maparg('<tab>', 'i', 0, 1)
  if placeholderCount != 0
    g:snippetPlaceholderCount = placeholderCount
    inoremap <tab> <c-r>=JumpSnippet()<cr>
  endif
enddef

var id = 0
def g:JumpSnippet(): string
  var prop = prop_find({ type: propPlaceholder, id: id, skipstart: 1 }, 'f')
  if empty(prop)
    prop = prop_find({ type: propPlaceholder, id: id, skipstart: 1 }, 'b')
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
    if id >= g:snippetPlaceholderCount - 1
      SnippetReset()
    endif
    id += 1
    return "\<esc>" .. str
  endif
  return ''
enddef

def ResetSnippetJump(_: number)
  isSnippetJump = 0
enddef

def SnippetReset()
  mapset('i', 0, g:snippet_save_map)
enddef

def g:SnippetHandleInsertLeave()
  if isSnippetJump == 0
    prop_remove({ type: propPlaceholder, all: 1 })
    SnippetReset()
  endif
enddef

au InsertLeavePre * SnippetHandleInsertLeave()
au Filetype * call LoadSnippet()
inoremap <tab> <c-r>=ExpandSnippet()<cr>
smap <tab> <esc>i<tab>
