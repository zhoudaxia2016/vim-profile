vim9script
compiler eslint

import { WebdevelopInit } from '../autoload/webdevelop.vim'
WebdevelopInit()

nnoremap <c-n><c-n> />\n\?\s*\zs[^< ]\+<cr>
nnoremap <c-n><c-a> /\%<c-r>=line('.')<cr>l\w\+="\zs<cr>
nnoremap <c-n><c-e> /\%<c-r>=line('.')<cr>l\w\+="[^"]\+\zs<cr>
