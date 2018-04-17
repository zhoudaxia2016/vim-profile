" modify vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" quickfix
nnoremap <space> :make<cr>
nnoremap <leader>cn :cn<cr>
nnoremap <leader>cp :cp<cr>

" command line
nnoremap ; :

" select compiler
nnoremap <F6> :call SelectCompiler()<cr>

function SelectCompiler ()
  if (exists('b:compilers'))
    let index = input#radio('Select a compiler', b:compilers)
    exec 'compiler ' . b:compilers[index-1]
  endif
endfunction

" file manager
noremap <F7> :!nautilus . &<cr><cr>
