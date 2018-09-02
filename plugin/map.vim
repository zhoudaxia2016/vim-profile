" open chrome
nnoremap <F12> :!cmdtool wstartex "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" %<cr><cr>

" file manager
noremap <F7> :!nautilus . &<cr><cr>
noremap <leader>,f :!nautilus . &<cr><cr>

" open a help file
" need to prohibit the terminal <F1> binding
nnoremap <expr> <F1>  <SID>openHelpFile()
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
