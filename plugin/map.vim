" modify vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" quickfix
nnoremap <space> :make<cr>
nnoremap <leader>cn :cn<cr>
nnoremap <leader>cp :cp<cr>

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

" complete
inoremap <c-k> <c-x><c-k>
inoremap <c-l> <c-x><c-l>
inoremap <c-t> <c-x><c-t>
inoremap <c-f> <c-x><c-f>
inoremap <c-d> <c-x><c-d>
inoremap <c-o> <c-x><c-o>
inoremap <c-i> <c-x><c-i>

" open a help file
" need to prohibit the terminal <F1> binding
nnoremap <expr> <F1>  <SID>openHelpFile()
nnoremap <F12> :helpc<cr>
function <SID>openHelpFile ()
  echohl Question
  let filename = input("Please input the help file name: ", "", "help")
  echohl None
  return ':h ' . filename . "\<cr>"
endfunction
