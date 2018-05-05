let express = require('express')
let path = require('path')
let host = 'localhost'
let port = 3000
let app = express()

app.get('/', function (req, res) {
  res.sendFile(path.resolve(__dirname, 'index.html'))
})
app.use('/static', express.static('{{!frame:react}}src{{/frame:react}}{{#frame:react}}dist{{/frame:react}}'))

let server = app.listen(port, function () {
  console.log('Example app listening at http://%s:%s', host, port)
})
