com -nargs=* Remote call <SID>remoteEdit(<f-args>)
ca rem Remote

let s:protocol = 'sftp'
let s:default_host = 'localhost'
let s:default_user = 'root'

function RemoteOutHandler (ch, msg)
  if (a:msg =~ 'Ssh socket start up!')
    exe "e sftp://".b:user."@".b:host."/".b:path
  endif
endfunc

function RemoteErrHandler (ch, msg)
  echom "RemoteEdit Error: " . a:msg
endfunc

function <SID>remoteEdit (...)
  let path = ''
  if a:0 == 0
    let b:host = s:host
    let b:user = s:user
  elseif a:0 == 1
    let b:host = a:1
  elseif a:0 == 2
    let b:host = a:1
    let b:user = s:user
    let b:path = a:2
  else
    let b:host = a:1
    let b:path = a:2
    let b:user = a:3
  endif
  let password = input("请输入密码: ")
  let job = job_start(expand('$HOME') . '/.vim/tools/startUpSshSocket.sh ' . b:user . ' ' . password . ' ' . b:host, {
        \ "out_cb": "RemoteOutHandler",
        \ "err_cb": "RemoteErrHandler"})
endfunc

" fix: 从远程文件返回，没有到当前目录
au BufReadPost sftp://* nnoremap <c-o> :Rex<cr>
