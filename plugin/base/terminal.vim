augroup nvim_terminal | au!
  autocmd TermOpen term://* startinsert
  autocmd TermClose * exe 'bdelete! '..expand('<abuf>')
augroup end
nnoremap <c-z> :term<cr>
tnoremap <esc> <c-\><c-n>
