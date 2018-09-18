let express = require('express')
let path = require('path')
let fs = require('fs')

let host = 'localhost'
let port = 3000
let app = express()
let chokidar = require('chokidar')
let baseDir = __dirname
let mdfile = process.argv[2]

// 编译markdown的插件
let showdown = require('showdown'),
  converter = new showdown.Converter()
converter.setOption('tables', true)
converter.setOption('tasklists', true)
converter.setOption('underline', true)
converter.setOption('emoji', true)

// 设置模板引擎handlebars
let exphbs  = require('express-handlebars')
app.set('views', baseDir + '/views')
app.engine('.hbs', exphbs({extname: '.hbs'}))
app.set('view engine', '.hbs')

app.get('/', function (req, res) {
  let content = fs.readFileSync(mdfile)
  let md
  if (content) {
    md = content.toString()
  } else {
    md = ''
  }
  html = converter.makeHtml(md)
  res.render('index.hbs', {html})
})

app.use('/static', express.static(baseDir + '/src'))

let server = app.listen(port, function () {
  console.log('Example app listening at http://%s:%s', host, port)
})

let io = require('socket.io')(server)

fs.watch(mdfile, (event, fn) => {
  md2html(fn)
})

function md2html (fn) {
  fs.readFile(fn, (err, content) => {
    let md = content.toString()
    let html = converter.makeHtml(md)
    io.emit('update', {
      update: true,
      html
    })
  })
}

// 打开浏览器
let c = require('child_process')
c.exec(`xdg-open http://${host}:${port}`)