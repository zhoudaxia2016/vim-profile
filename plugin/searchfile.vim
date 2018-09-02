nnoremap <leader>q :call <SID>searchFile()<cr>

set path+=**
set wildmenu

function <SID>searchFile ()
  let file = input#input('Input file name', 'file_in_path')
  if (file != '')
    exe 'find ' . file
  endif
endfunc
