autocmd BufReadPost * call <SID>lastPosJump()

function <SID>lastPosJump ()
  if &ft !~# 'commit'
    if line("'\"") >= 1 && line("'\"") <= line("$")
      exe "normal! g`\""
    elseif line("'\"") > line("$")
      exe "normal! G"
    endif
  endif
endfunction
