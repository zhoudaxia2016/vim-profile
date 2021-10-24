function ShowFileFormatFlag()
  return '[' . &fileformat . ']'
endfunction
let s:modes = #{ i: 'Insert', n: 'Normal' }
function ShowMode()
  let m = mode()
  if has_key(s:modes, m)
    return s:modes[m]
  endif
  return ''
endfunction

set laststatus=2
set statusline=\ --%{ShowMode()}--\ \ %y\%{ShowFileFormatFlag()}\ \ line:%l\ \ col:%c%=
set statusline+=%<%L\ %F\ %p%%\ 
