let s:input_method = -1
function s:setInputMethod(ch, msg)
  let s:input_method = a:msg
  " 设置为英文输入法
  call job_start('im-select.exe 1033')
endfunc
function HandleInsertChange(isEnter)
  if a:isEnter == 1
    if s:input_method != -1
      " 还原输入法
      call job_start('im-select.exe ' . s:input_method)
    endif
  else
    " 获取当前输入法
    call job_start('im-select.exe', #{ out_cb: function('s:setInputMethod') })
  endif
  return ''
endfunc

au InsertEnter * call HandleInsertChange(1)
inoremap <esc> <c-r>=HandleInsertChange(0)<cr><esc>
