" complete
inoremap <c-k> <c-x><c-k>
inoremap <c-l> <c-x><c-l>
inoremap <c-t> <c-x><c-t>
inoremap <c-f> <c-x><c-f>
inoremap <c-d> <c-x><c-d>
inoremap <c-o> <c-x><c-o>
inoremap <c-i> <c-x><c-i>

function! CleverTab()
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<tab>"
  else
    return "\<C-N>"
  endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

set cpt+=k
