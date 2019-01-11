runtime! indent/html.vim
let g:html_indent_inctags = substitute(utils#readDict('mp'), ' ', ',', 'g')
call HtmlIndent_CheckUserSettings()
