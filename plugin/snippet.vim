vim9script
const propPlaceholderColor = '#e9c496'
const propPlaceholder = 'snippet-placeholder'
exec 'hi snippet guifg=' .. propPlaceholderColor
prop_type_add(propPlaceholder, {highlight: 'snippet'})
au InsertLeavePre * snippet#SnippetHandleInsertLeave()
au Filetype * call snippet#LoadSnippet()
smap <tab> <esc>i<tab>
