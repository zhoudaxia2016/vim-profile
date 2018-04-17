" quickfix window
nnoremap <F2> :call QuickfixToggle()<cr>

let g:quickfix_is_open = 0
function! QuickfixToggle ()
  if g:quickfix_is_open
    cclose
      let g:quickfix_is_open = 0
  else
    copen
      let g:quickfix_is_open = 1
  endif
endfunction

" Toggle paste
nnoremap <F4> :call PasteToggle()<cr>

function! PasteToggle ()
  set paste!
endfunction

" Toggle number
nnoremap <F5> :call NumberToggle()<cr>

function! NumberToggle ()
  set relativenumber!  
  set number!
endfunction
