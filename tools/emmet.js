const expand = require('emmet').default
console.log(expand(process.argv[2], {
  snippets: {
    "if": "abc"
  },
  options: { 'output.field':  () => '@@' }
}))
