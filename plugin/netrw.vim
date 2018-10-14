let netrw_banner = 0
let g:netrw_dirhistmax = 0
let g:netrw_browse_split = 0
let g:netrw_list_hide= '^\.'
let g:netrw_winsize=16
let g:netrw_bufsettings="nonu rnu wrap"
let g:netrw_use_noswf= 0
set autochdir

function! ToggleExplorer()
  if exists("t:expl_buf_num")
    let expl_win_num = bufwinnr(t:expl_buf_num)
    if expl_win_num != -1
      let cur_win_nr = winnr()
      exec expl_win_num . 'wincmd w'
      close
      exec cur_win_nr . 'wincmd w'
      unlet t:expl_buf_num
    else
        unlet t:expl_buf_num
    endif
  else
    exec '1wincmd w'
    Lexplore .
    let t:expl_buf_num = bufnr("%")
  endif
endfunction

nnoremap <silent> <leader>d :call ToggleExplorer()<cr>

setlocal splitright

autocmd filetype netrw call Netrw_mappings()
function! Netrw_mappings()
  noremap <buffer> % :call CreateInPreview()<cr>
  noremap <buffer> f :call SplitFile()<cr>
  noremap <buffer> ( :call CreateFile()<cr>
endfunc

function! CreateInPreview ()
  let l:fn = input#input("Please enter filename")
  exec 'silent !touch ' . b:netrw_curdir. '/' .l:fn
  redraw!
endfunc

function! SplitFile ()
  let l:fn = GetCursorFile()
  exec 'silent vs ' . b:netrw_curdir. '/' .l:fn
  redraw!
endfunc

function! CreateFile ()
  let l:fn = input#input("Please enter filename")
  exec 'silent vs ' . b:netrw_curdir. '/' .l:fn
  redraw!
endfunc

function! GetCursorFile ()
  return trim(getline('.'))
endfunc
