function tmux#window(opts)
  let cmd = get(a:opts, 'cmd', '')
  let input = get(a:opts, 'input', '')
  let root = get(a:opts, 'root', 1)
  let Callback = get(a:opts, 'callback', '')
  let wholeCmd = 'tmux-window.sh'
  let jobOpts = #{}

  let output = ''
  if cmd != ''
    let wholeCmd = wholeCmd . ' -f "' . cmd . '"'
  endif
  let opts = {}
  if Callback != ''
    let outputFile = tempname()
    let wholeCmd = wholeCmd . ' -o ' . outputFile
    function opts.exit_cb(...) closure
      echom outputFile
      if filereadable(outputFile)
        let output = readfile(outputFile)
        if len(output) != 0
          call Callback(output)
          return
        endif
        call timer_start(500, opts.exit_cb)
      endif
    endfunc
    let jobOpts.close_cb = {ch -> timer_start(500, opts.exit_cb)}
  endif
  if root
    let wholeCmd = wholeCmd . ' -r '
  endif
  if input != ''
    let inputFile = tempname()
    let wholeCmd = wholeCmd . ' -i ' . inputFile
    redir => cmdInput
    exec 'silent ' . input
    redir END
    let cmdInput = split(cmdInput, '\n')
    call writefile(cmdInput, inputFile)
  endif
  call job#start(wholeCmd, jobOpts)
endfunc
