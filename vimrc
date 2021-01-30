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
set foldmethod=indent
set foldlevel=3
set foldopen+=jump
set shortmess-=S
set ffs=unix,dos
set hidden

"colors nord
colors nord
set list listchars=trail:_

if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
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
set nowritebackup
set fileencodings=utf-8,chinese,latin-1,gbk,gb18030,gk2312

let g:netrw_use_noswf= 0
source $VIMRUNTIME/menu.vim
set wildmenu                                                                                                                                                     
set cpo-=<
set wcm=<C-Z>
map <F3> :emenu <C-Z>

hi Pmenu guibg=#21252B guifg=#CCCCCC
hi PmenuSel guibg=#91BC77 guifg=#282C34

if &diff
  set noreadonly
endif

let g:netrw_browsex_viewer="cmd.exe /C start"
let html_no_rendering = 1
let g:vim_json_conceal=0
au VimEnter * if &diff | execute 'windo set wrap' | endif

hi TabLineFill ctermfg=2 ctermbg=0
hi TabLine ctermfg=2 ctermbg=0
hi TabLineSel term=bold ctermfg=0 ctermbg=2
