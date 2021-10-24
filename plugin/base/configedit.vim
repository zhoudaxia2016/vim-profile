" modify vimrc
nnoremap <leader>ev :tabnew $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>ep :tabnew ~/.vim/templates/projects<cr>
nnoremap <leader>et :tabnew ~/.vim/templates/files<cr>
nnoremap <leader>ee :tabnew ~/.vim/plugin/<cr>
au Filetype * call FiletypeMap()

function! FiletypeMap ()
  let ft = expand("<amatch>")
  exe "nnoremap <leader>ek :tabnew ~/.vim/dict/" . ft . ".dict<cr>"
  exe "nnoremap <leader>ef :tabnew ~/.vim/ftplugin/" . ft . ".vim<cr>"
  exe "nnoremap <leader>es :tabnew ~/.vim/snippets/" . ft . ".json<cr>"
endfunc
