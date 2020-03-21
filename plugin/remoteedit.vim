com -nargs=* Remote call <SID>remoteEdit(<f-args>)
ca rem Remote

let s:protocol = 'sftp'

function RemoteOutHandler (ch, msg)
  if (a:msg =~ 'Ssh socket start up!')
    exe "e sftp://" . b:host . "/" . b:path
  endif
endfunc

function RemoteErrHandler (ch, msg)
  echom "e sftp://" . b:host . "/" . b:path
  echom "RemoteEdit Error: " . a:msg
endfunc

function <SID>remoteEdit (host, path)
  let b:host = a:host
  let b:path = a:path
  let job = job_start(expand('$HOME') . '/.vim/tools/startUpSshSocket.sh ' . a:host, {
        \ "out_cb": "RemoteOutHandler",
        \ "err_cb": "RemoteErrHandler"})
endfunc

" fix: 从远程文件返回，没有到当前目录
au BufReadPost sftp://* nnoremap <c-o> :Rex<cr>
