nnoremap <buffer> <leader>m :call <SID>make()<cr>

function <SID>make ()
  let cmd = "elm make --report=json " . expand("%:p")
  let b:output = system(cmd)
  if b:output == ''
    echo "Compile successfully!"
    return
  endif
  let json = json_decode(b:output)
  let formatErrors = []
  echo json
  for error in json.errors
    call add(formatErrors, {'filename': error.path,
          \'valid': 1,
          \'lnum': error.problems[0].region.start.line,
          \'col': error.problems[0].region.start.column,
          \'text': join(map(error.problems[0].message, funcref("ElmCompilerGetErrMsg")))})
  endfor
  cfirst
  call setqflist(formatErrors)
endfunc

function ElmCompilerGetErrMsg (key, value)
  if type(a:value) == v:t_string
    return a:value
  endif
  return ''
endfunc
