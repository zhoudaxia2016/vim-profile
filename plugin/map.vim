" quickfix
nnoremap cn :cn<cr>
nnoremap cp :cp<cr>

" open chrome
nnoremap <F12> :!cmdtool wstartex "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" %<cr><cr>

" file manager
noremap <F7> :!nautilus . &<cr><cr>
noremap <leader>,f :!nautilus . &<cr><cr>

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

" open a help file
" need to prohibit the terminal <F1> binding
nnoremap <expr> <F1>  <SID>openHelpFile()
nnoremap <expr> <leader><leader>  <SID>openHelpFile()
function <SID>openHelpFile ()
  echohl Question
  let filename = input("Please input the help file name: ", "", "help")
  echohl None
  return ':h ' . filename . "\<cr>"
endfunction

" move around window
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-i> <c-w><c-t>
nnoremap <c-b> <c-w><c-b>
nnoremap <c-p> <c-w><c-p>
nnoremap <tab> <c-w><c-w>

nnoremap <F9> :message<cr>
nnoremap <leader>,e :message<cr>
nnoremap <F8> :set list!<cr>
nnoremap <leader>,l :set list!<cr>
nnoremap <leader>z :!google-chrome %<cr>

nnoremap <leader>l :exec exists('syntax_on') ? 'syn off': 'syn on'<CR>

nnoremap <leader>s :w !sudo tee %<cr>
nnoremap ; :
