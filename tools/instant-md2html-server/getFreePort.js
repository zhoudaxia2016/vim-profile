let net = require('net')

async function getFreePort (port, callback, interval = 1) {
  while (true) {
    if (await isFreePort(port)) {
      callback(port)
      break
    }
    port += interval
  }
}

function isFreePort (port) {
  return new Promise(res => {
    let server = net.createServer().listen(port)
    server.on('listening', function () { // 执行这块代码说明端口未被占用
      server.close() // 关闭服务
      res(true)
    })
    server.on('error', function (err) {
      if (err.code === 'EADDRINUSE') { // 端口已经被使用
        res(false)
      }
    })
  })
}

module.exports = getFreePort
