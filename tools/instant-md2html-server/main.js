let getFreePort = require('./getFreePort')

let host = 'localhost'
let port = 3000
let baseDir = __dirname
let mdfile = process.argv[2]
let theme = 'github'
if (process.argv.length > 3) {
  theme = process.argv[3]
}

let c = require('child_process')
c.exec(`gulp --cwd=${__dirname} --${mdfile} --${port} --${theme}`)
// 打开浏览器
setTimeout(() => {
  c.exec(`gulp --cwd=${__dirname} --${mdfile} --${port} --${theme}`, err => {
    console.error(err)
  })
  c.exec(`cmd.exe /C start http://${host}:${port}`)
})
