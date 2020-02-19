let netrw_banner = 0
let g:netrw_dirhistmax = 0
let g:netrw_browse_split = 0
let g:netrw_list_hide= '^\.'
let g:netrw_winsize=16
let g:netrw_bufsettings="nonu rnu wrap"
let g:netrw_use_noswf= 0
set autochdir

function! ToggleExplorer()
  " 是否打开目录树buffer
  if exists("t:expl_buf_num")
    let expl_win_num = bufwinnr(t:expl_buf_num)
    " 打开了目录树窗口
    if expl_win_num != -1
      let cur_win_nr = winnr()
      " 先进入目录树窗口
      exec expl_win_num . 'wincmd w'
      " 是否已经在目录树窗口，是则关闭目录树，否则什么都用做
      if (cur_win_nr == expl_win_num)
        close
        let cur_win_nr = winnr()
        exec cur_win_nr . 'wincmd w'
        unlet t:expl_buf_num
      endif
    else
      unlet t:expl_buf_num
    endif
  else
    " 没有目录树buffer，则打开，保存buf number
    exec '1wincmd w'
    exec 'Lexplore ' . expand('%:p:h')
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
  vertical res 20
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
endfunc

function! GetCursorFile ()
  return substitute(trim(getline('.')), '\*', '', 'g')
endfunc
