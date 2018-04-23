nnoremap <F3> :call <SID>LoadProjectTemplate()<cr>

let s:project_root = $HOME . '/.vim/templates/projects/'
let s:var_json = 'var.json'
let s:projectList = ['react-html', 'rollup', 'react-webpack']

function! <SID>LoadProjectTemplate ()
  let pn = input#radio("What's the project template's name?", s:projectList)	
  let pn = s:projectList[pn-1]
  call feedkeys("\<CR>")
  let project_path = s:project_root . pn . '/'
  if finddir(project_path) == ''
    call Err("\nThe project template isn't existed!!")
    return
  endif

  let var_json = project_path . s:var_json
  let json = json#readfile(var_json)

  exec "!cp -r " . project_path  . "template/. ."

  " The key in the replace will be replaced with the corresponding value
  let replace = {}
  " The key in the boolean controls the content show or hide between the key
  let boolean = {}

  if type(json) != 0
    for [key, value] in items(json)
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
	let replace[key] = sel

      " y/N Question
      elseif value.type == 2
	let val = input#confirm("Use " . key . "?")
	let boolean[key] = val
      endif
    endfor
  endif

  args **/*.*
  for [key, value] in items(replace)
    let pattern = '{{\s*' . key . '\s*}}'
    exec 'argdo %s/' . pattern . '/' . value . '/ge | update'
  endfor

  for [key, value] in items(boolean)
    let rep = value ? '\1' : ''
    let pattern = '{{#\s*' . key . '\s*}}\(.*\){{\/\s*' . key . '\s*}}'
    exec 'argdo %s/' . pattern . '/' . rep . '/ge | update'
  endfor

endfunc

function! Err (str)
    echohl ErrorMsg
    echom a:str
    echohl None
endfunc 
