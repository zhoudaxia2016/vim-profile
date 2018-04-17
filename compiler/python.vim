" python compiler
let name = 'python'
if (!exists('g:current_compiler'))
  let g:current_compiler = name
else
  if (g:current_compiler == name)
    finish
  else
    let g:current_compiler = name
  endif
endif

let errorformat =
      \'%A  File "%f"\, line %l\,%m,' .
      \'%C    %.%#,' .
      \'%+Z%.%#Error: %.%#,' .
      \'%A  File "%f"\, line %l,' .
      \'%+C  %.%#,' .
      \'%-C%p^,' .
      \'%Z%m,'

let cmd = 'python3 %'

function! s:quickfixPost ()
  let qfl = getqflist()
  call setqflist(reverse(qfl))
endfunction

let &l:makeprg = cmd
let &l:errorformat = errorformat . '%-G%.%#'
au QuickFixCmdPost make call s:quickfixPost()
