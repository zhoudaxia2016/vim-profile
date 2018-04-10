set nu
set wrap
set nocompatible
filetype on
syntax on
set autoindent
set smartindent
set softtabstop=2
set shiftwidth=2
let mapleader=","
set backspace=indent,eol,start
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <F2> :!google-chrome %<cr>

colorscheme NeoSolarized
set background=dark
