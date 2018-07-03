inoremap <c-j> <c-r>=snippet#triggerSnippet()<cr>
exe "smap <c-j> \<esc>:call snippet#triggerSnippetAtSelectMode()\<cr>"
