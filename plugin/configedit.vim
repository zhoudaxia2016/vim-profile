" modify vimrc
nnoremap <leader>ev :Texplore $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>ep :Texplore ~/.vim/templates/projects<cr>
nnoremap <leader>et :Texplore ~/.vim/templates/files<cr>
nnoremap <leader>ee :Texplore ~/.vim/plugin/<cr>
au Filetype * call FiletypeMap()

function! FiletypeMap ()
  let ft = expand("<amatch>")
  exe "nnoremap <leader>ek :Texplore ~/.vim/dict/" . ft . ".dict<cr>"
  exe "nnoremap <leader>ef :Texplore ~/.vim/ftplugin/" . ft . ".vim<cr>"
  exe "nnoremap <leader>es :Texplore ~/.vim/snippets/" . ft . ".json<cr>"
endfunc
