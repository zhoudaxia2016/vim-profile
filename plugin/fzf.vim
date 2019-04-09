function! <SID>Open()
  let options = {'term_name': 'FZF', 'exit_cb': function('s:OpenFile'), 'vertical': 1}
  echo function('s:OpenFile')
  let b:term_buf = term_start('fzf', options)
endfunction

function s:OpenFile(...)
  let root = getcwd()
  let path = term_getline(b:term_buf, 1)
  if filereadable(path)
    execute 'edit '.root.'/'.path
  else
    close
  endif
endfunction

nnoremap <expr> <c-p> <SID>Open()
hi Terminal guibg=#3c4151 guifg=#dfe2e2
