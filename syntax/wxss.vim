runtime syntax/css.vim

syntax iskeyword @,48-57,192-255,$,-
let tagsStr = utils#readDict('mp')
exe "syn keyword cssTagName " . tagsStr

