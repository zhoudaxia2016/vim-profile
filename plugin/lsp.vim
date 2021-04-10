if !has('nvim')
  finish
endif
noremap <c-d><c-h> <Cmd>lua vim.lsp.buf.hover()<cr>
noremap <c-d><c-j> <Cmd>lua vim.lsp.buf.definition()<cr>
noremap <c-d><c-n> <Cmd>lua vim.lsp.diagnostic.goto_next()<cr>
noremap <c-d><c-p> <Cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
noremap <c-d><c-m> <Cmd>lua vim.lsp.buf.rename()<cr>
set omnifunc=v:lua.vim.lsp.omnifunc
set completeopt-=preview
hi LspDiagnosticsDefaultError ctermbg=1 ctermfg=253
hi LspDiagnosticsDefaultWarning ctermbg=5 ctermfg=black
hi LspDiagnosticsDefaultHint ctermbg=2 ctermfg=black
