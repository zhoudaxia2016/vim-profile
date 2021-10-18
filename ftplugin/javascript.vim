vim9script
# compiler
compiler eslint

# include file search
&l:include = 'import\s*\i*\s*from\|import\|require('

# define search
&l:define = '^\s*\(var\|let\|const\|class\|import\|function\)'

# path
set path=./node_modules;./

#import { WebdevelopInit } from '../autoload/webdevelop.vim'
#WebdevelopInit()
