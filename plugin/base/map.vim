" file manager
noremap <F7> :!nautilus . &<cr><cr>
noremap <leader>,f :!nautilus . &<cr><cr>

" open a help file
" need to prohibit the terminal <F1> binding
nnoremap <expr> <F1>  <SID>clip()
nnoremap <expr> <leader><leader>  <SID>openHelpFile()
function <SID>openHelpFile ()
  echohl Question
  let filename = input("Please input the help file name: ", "", "help")
  echohl None
  if (filename == '')
    return ''
  endif
  return ':h ' . filename . "\<cr>"
endfunction

function <SID>clip ()
  silent %w !clip.exe
endfunc

" move around window
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-b> <c-w><c-b>

nnoremap <F9> :message<cr>
nnoremap <leader>,e :message<cr>
nnoremap <F8> :set list!<cr>
nnoremap <leader>,l :set list!<cr>
nnoremap <leader>z :!google-chrome %<cr>

"nnoremap <leader>l :(&filetype != 'netrw') ? (exec exists('syntax_on') ? 'syn off': 'syn on'<CR>) : '<CR>'

nnoremap <leader>s :w !sudo tee %<cr>
nnoremap ; :
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap vA ggVG
nnoremap <c-e> <c-v>
nnoremap <c-z> :sh<cr>
