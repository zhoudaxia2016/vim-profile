set nu
set relativenumber
set swb=useopen
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
set wrap
set nocompatible
filetype indent on
filetype plugin on
syntax on
set softtabstop=2
set shiftwidth=2
set noswapfile
let mapleader=","
set backspace=indent,eol,start
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <F2> :!google-chrome %<cr>

colorscheme NeoSolarized
set background=dark
