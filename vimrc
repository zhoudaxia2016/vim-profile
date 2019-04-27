set nu
set relativenumber
set scrolloff=3
set swb=useopen
set relativenumber
set wrap
set nocompatible
filetype indent on
filetype plugin on
syntax on
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab
set noswapfile
let mapleader=" "
set backspace=indent,eol,start

colors snazzy
set list listchars=trail:_

if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif
set lazyredraw
set ttyfast

" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete
set undofile
set undodir=/tmp/
set ignorecase
set cursorline
" operator mappings
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)
