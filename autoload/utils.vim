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
    let path = cur . a:flagFileOrDir
    if file_readable(path) || isdirectory(path)
      return trim(system('realpath ' . (cur == '' ? '.' : cur)))
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
    if has('nvim')
      return json_decode(config)
    else
      return js_decode(config)
    endif
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

func utils#debounce(fn)
  let timer = v:null
  let funs = {}
  let funs.fn = a:fn
  function funs.wrapperFunc(...) closure
    let funs.callFn = function(funs.fn, a:000[:-2])
    call funs.callFn()
  endfunc
  function funs.returnFunc(...) closure
    if timer != v:null
      call timer_stop(timer)
    endif
    let timer = timer_start(200, function(funs.wrapperFunc, a:000))
  endfunc
  return funs.returnFunc
endfunc
