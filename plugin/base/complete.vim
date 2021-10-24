" 补全
inoremap <c-k> <c-x><c-k>
inoremap <c-l> <c-x><c-l>
inoremap <c-t> <c-x><c-t>
inoremap <c-f> <c-x><c-f>
inoremap <c-d> <c-x><c-d>
inoremap <c-o> <c-x><c-o>
inoremap <c-i> <c-x><c-i>

function! CleverTab()
  if getline('.')[col('.')-2] =~ '\s'
    return "\<Tab>"
  else
    return "\<c-n>"
  endif
endfunction
imap <Tab> <C-R>=CleverTab()<CR>

set cpt+=k
