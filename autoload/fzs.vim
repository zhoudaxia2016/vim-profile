function fzs#run(opts)
  let cmd = get(a:opts, 'cmd', '')
  let isVimCmd = get(a:opts, 'isVimCmd', 0)
  let preview = get(a:opts, 'preview', '')
  let termOpts = get(a:opts, 'termOpts', {})
  let fzfOpts = get(a:opts, 'fzfOpts', '')
  let setRoot = get(a:opts, 'setRoot', 0)
  let actions = get(a:opts, 'actions', v:null)
  let hasActions = type(actions) == type({})
  let fzs = #{ buf: '', win: '', cb: get(a:opts, 'cb') }

  if cmd != ''
    redir => output
    if isVimCmd
      exec 'silent ' . cmd
    else
      exec 'silent echo system("' . cmd . '")'
    endif
    redir END
    let output = split(output, '\n')
    let tmpfile = tempname()
    call writefile(output, tmpfile)
  endif

  function fzs.termExit(...) closure
    if hasActions
      let key = term_getline(fzs.buf, 1)
      let result = term_getline(fzs.buf, 2)
    else
      let result = term_getline(fzs.buf, 1)
    endif
    call term_wait(fzs.buf, 5000)
    call popup_close(fzs.win)
    if hasActions && key != '' 
      if setRoot
        call actions[key](termOpts.cwd, result)
      else
        call actions[key](result)
      endif
    else
      if setRoot
        call fzs.cb(termOpts.cwd, result)
      else
        call fzs.cb(result)
      endif
    endif
  endfunc

  let termOpts.hidden = 1
  let termOpts.exit_cb = function(fzs.termExit)

  if cmd != ''
    let fullCmd = 'cat ' . tmpfile . ' | fzf'
  else
    let fullCmd = 'fzf'
  endif
  if preview != ''
    let fullCmd = fullCmd . ' --preview "' . preview . '"'
  endif
  if hasActions
    let fullCmd .= ' --expect "' . join(keys(actions), ',') . '"'
  endif
  if fzfOpts != ''
    let fullCmd .= ' ' . fzfOpts
  endif
  if setRoot
    let root = utils#findRoot('.git')
    let origin_path = getcwd()
    if root == v:null
      let root = utils#findRoot('package.json')
    endif
    if root == v:null
      let root = '.'
    endif
    let termOpts.cwd = root
  endif
  let fzs.buf = term_start(['sh', '-c', fullCmd], termOpts)
  let fzs.win = popup_create(fzs.buf, #{minheight: 20, minwidth:100})
endfunc
