let express = require('express')
let path = require('path')
let host = 'localhost'
let port = 3000
let app = express()
let chokidar = require('chokidar')

app.get('/', function (req, res) {
  res.sendFile(path.resolve(__dirname, 'index.html'))
})
app.use('/static', express.static('{{!frame:react}}src{{/frame:react}}{{#frame:react}}dist{{/frame:react}}'))
{{#refresh:poll}}
let change = false
let watcher = chokidar.watch('./src')
watcher.on('all', function (event, path) {
  change = true
  console.log('File: ', path)
  console.log('Event: ', event)
})

// 短轮询
app.use('/need/to/update', function (req, res) {
  res.send(change)
  if (change) {
    change = false
  }
})
{{/refresh:poll}}
let server = app.listen(port, function () {
  console.log('Example app listening at http://%s:%s', host, port)
})
{{#refresh:socketio}}
let io = require('socket.io')(server)

let watcher = chokidar.watch('./src')
watcher.on('all', function (event, path) {
  io.emit('message', { change: true })
  console.log('File: ', path)
  console.log('Event: ', event)
}){{/refresh:socketio}}
