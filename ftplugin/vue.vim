vim9script
setlocal omnifunc=vuecomplete#CompleteVUE
compiler eslint

import { WebdevelopInit } from '../autoload/webdevelop.vim'
WebdevelopInit()
