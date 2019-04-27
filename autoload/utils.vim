func utils#Eatchar(pat)
  let c = nr2char(getchar(0))
  echom a:pat
  return (c =~ a:pat) ? '' : c
endfunc

func utils#findRoot (flagFileOrDir)
  let cur = ''
  let c = 0
  while (c < 10)
    let c += 1
    if file_readable(cur . a:flagFileOrDir) || isdirectory(cur . a:flagFileOrDir)
      return trim(system('realpath ' . cur))
    endif
    let cur .= '../'
  endwhile
  return v:null
endfunc

func utils#readDict (name)
  let dictDir = expand('$HOME') . '/.vim/dict/'
  let lines = readfile(dictDir . a:name . '.dict')
  return join(lines, ' ')
endfunc

" 使用js-yaml读取yaml配置文件
func utils#readConfig (fn)
  let config = system('js-yaml ' . a:fn)
  try
    return js_decode(config)
  catch /.*/
    echoerr config
  endtry
endfunc

" 加载yaml配置文件
func utils#loadConfig (fn)
  let config = utils#readConfig(a:fn)
  for key in keys(config)
    exe 'let ' . key . ' = ' . 'config["' . key . '"]'
  endfor
endfunc
