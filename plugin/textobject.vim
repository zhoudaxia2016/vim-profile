onoremap - :call <SID>selectBetweenUnderline()<cr>

function <SID>selectBetweenUnderline ()
  if stridx(getline('.')[:col('.')-1], '_') == -1
    normal bvt_
  else
    normal T_vt_
  endif
endfunc
