inoremap <c-j> <c-r>=snippet#triggerSnippet()<cr>
exe "smap <c-j> \<esc>:call snippet#triggerSnippetAtSelectMode()\<cr>"

let g:snippet_filetypes = {
  \'html': ['vue', 'javascript', 'css']
  \}

let g:snippet_cache = {}
