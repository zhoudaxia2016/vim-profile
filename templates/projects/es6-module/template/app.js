let express = require('express')
let path = require('path')
let host = 'localhost'
let port = 3000
let app = express()
let chokidar = require('chokidar')

app.get('/', function (req, res) {
  res.sendFile(path.resolve(__dirname, 'index.html'))
})
app.use('/static', express.static('{{#if_eq frame react}}dist{{#else}}src{{/if_eq}}'))
let change = false
let watcher = chokidar.watch('./{{#if_eq frame react}}dist{{#else}}src{{/if_eq}}')
watcher.on('all', function (event, path) {
  change = true
  console.log(event, ': ', path)
})

{{#if_eq refresh poll}}
// 短轮询
app.use('/need/to/update', function (req, res) {
  res.send(change)
  if (change) {
    change = false
  }
})
{{/if_eq}}
let server = app.listen(port, function () {
  console.log('Example app listening at http://%s:%s', host, port)
})
{{#if_eq refresh socketio}}
let io = require('socket.io')(server)
{{/if_eq}}
