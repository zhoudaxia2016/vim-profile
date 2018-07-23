" modify vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>ep :vsplit ~/.vim/templates/projects<cr>
nnoremap <leader>et :vsplit ~/.vim/templates/files<cr>
nnoremap <leader>ee :vsplit ~/.vim/plugin/<cr>
au Filetype * call FiletypeMap()

function! FiletypeMap ()
  let ft = expand("<amatch>")
  exe "nnoremap <leader>ek :vsplit ~/.vim/dict/" . ft . ".dict<cr>"
  exe "nnoremap <leader>ef :vsplit ~/.vim/ftplugin/" . ft . ".vim<cr>"
endfunc
