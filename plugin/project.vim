nnoremap <F3> :call <SID>LoadProjectTemplate()<cr>

let s:project_root = $HOME . '/.vim/templates/projects/'
let s:var_json = 'var.json'
let s:projectList = ['es6-module', 'rollup', 'react-webpack']

function! <SID>LoadProjectTemplate ()

  " Get the template's directory
  let pn = input#radio("What's the project template's name?", s:projectList)	
  let pn = s:projectList[pn-1]
  call feedkeys("\<CR>")
  let project_path = s:project_root . pn . '/'
  if finddir(project_path) == ''
    call <SID>Err("\nThe project template isn't existed!!")
    return
  endif

  " Deal with the var
  let var_json = project_path . s:var_json
  let json = json#readfile(var_json)

  exec "!cp -r " . project_path  . "template/. ."

  " The key in the replace will be replaced with the corresponding value
  let replace = {}
  " The key in the boolean controls the content show or hide between the key
  let boolean = {}
  let option = {}

  if type(json) != 0

    if has_key(json, 'prompts')
      let prompts = get(json, 'prompts')
      for [key, value] in items(prompts)
	" Input Question
	if value.type == 0
	  let val = input#input("What's the project's " . key)
	  if val != ''
	    let replace[key] = val
	  else 
	    try
	      let replace[key] = value.default
	    catch '.*'
	      return
	    endtry
	  endif

	  " Single choice Question
	elseif value.type == 1
	  let val = input#radio("which " . key . '?', value.list)
	  if val == 0
	    return
	  endif
	  let sel = value.list[val-1]
	  let option[key] = sel

	  " y/N Question
	elseif value.type == 2
	  let val = input#confirm("Use " . key . "?")
	  let boolean[key] = val
	endif
      endfor
    endif

    if has_key(json, 'filters')
      let filters = json['filters']
    endif
    if has_key(json, 'message')
      let message = json['message']
    endif
  endif

  args **/*.*
  for [key, value] in items(replace)
    let pattern = '{{\s*' . key . '\s*}}'
    exec 'argdo %s/' . pattern . '/' . value . '/ge | update'
  endfor

  for [key, value] in items(boolean)
    let rep = value ? '\1' : ''
    let pattern = '{{#\s*' . key . '\s*}}\(\_.*\){{\/\s*' . key . '\s*}}'
    exec 'argdo %s/' . pattern . '/' . rep . '/ge | update'
  endfor

  for [key, value] in items(option)
    for opt in prompts[key].list
      let rep = (value == opt) ? '\1' : ''
      let label = key . ':' . opt
      let pattern = '{{#\s*' . label . '\s*}}\(\_.\{-}\){{\/\s*' . label . '\s*}}'
      exec 'argdo %s/' . pattern . '/' . rep . '/ge | update'
    endfor
  endfor

  " Prevent to replace the {{}} for vue, use {%{}%}
  argdo %s/{%{\(\_.\{-}\)}%}/{{\1}}/ge | update

  if exists('filters')
    for [key, value] in items(filters)
      let splits = split(value, ':')
      if len(splits) != 1
	let filter = get(option, splits[0]) == splits[1]
      else
	let filter = get(boolean, splits[0])
      endif	
      if !filter
	exec '!rm ' . key
	call feedkeys("\<CR>")
      endif
    endfor
  endif

  if exists('message')
    echom substitute(message, '{\([^}]*\)}', '\=<SID>GetValue(replace, option, submatch(1))', 'g') 
  endif

endfunc

function <SID>GetValue (replace, option, key)
  let value = get(a:replace, a:key, v:null)
  if value != v:null
    return value
  endif
  let value = get(a:option, a:key, v:null)
  if value != v:null
    return value
  endif
  call <SID>Err('The value does not exist!')
endfunc

function <SID>Err (str)
  echohl ErrorMsg
  echom a:str
  echohl None
endfunc 
