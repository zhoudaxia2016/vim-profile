set nu
set wrap
set nocompatible
filetype indent on
syntax on
set softtabstop=2
set shiftwidth=2
let mapleader=","
set backspace=indent,eol,start
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <F2> :!google-chrome %<cr>

colorscheme NeoSolarized
set background=dark

autocmd BufNewFile  *.html	0r ~/.vim/templates/html.tpl
