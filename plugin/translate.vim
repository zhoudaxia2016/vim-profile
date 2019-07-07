" 使用npm包 cli-dict 来做翻译，并使用popup window
function! <SID>translate ()
  normal! viwy
  let result = []
  function! s:callback (c, r) closure
    call add(result, a:r)
  endfunc
  function! s:close (c) closure
    call map(result, 'trim(v:val)')
    call popup_atcursor(result[1:], { 'padding': [1, 2, 0, 2], 'borderchars': ['-', '|', '-', '|'], 'border': [1] })
  endfunc
  call job_start('dict ' . @0, { 'callback': funcref('s:callback'), 'close_cb': funcref('s:close') })
endfunc

nnoremap <leader>t :call <SID>translate()<cr>

