" 使用npm包 cli-dict 来做翻译，并使用popup window
function! <SID>translate ()
  normal! viwy
  let result = []
  function! s:callback (c, r) closure
    call add(result, a:r)
  endfunc
  function! s:close (c) closure
    call map(result, 'trim(v:val)')
    if has('nvim')
      let buf = nvim_create_buf(v:false, v:true)
      call nvim_buf_set_lines(buf, 0, -1, v:true, result[2:])
      let id = nvim_open_win(buf, v:false, #{ relative:'cursor',row:1,col:0,width:20,height:5})
      call timer_start(2000, {-> nvim_win_close(id, v:true)})
    else 
      call popup_atcursor(result[1:], { 'padding': [1, 2, 0, 2], 'borderchars': ['-', '|', '-', '|'], 'border': [1] })
    endif
  endfunc
  call job#start('dict ' . @0, { 'out_cb': funcref('s:callback'), 'close_cb': funcref('s:close') })
endfunc

nnoremap <leader>t :call <SID>translate()<cr>

