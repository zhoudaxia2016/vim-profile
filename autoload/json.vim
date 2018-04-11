function! json#readfile (fn)
  try
    let lines = readfile(a:fn)
    let str = join(lines)
    let json = json_decode(str)
    return json
  catch ".*"
    echo "Not such file!!!"
  endtry
endfunc
