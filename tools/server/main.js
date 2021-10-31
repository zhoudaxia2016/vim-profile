const express = require('express')
const app = express()
const port = process.env.EDITOR_PORT
const { attach } = require('neovim')
const socketAddr = process.argv[2]

app.get('/', (req, res) => {
  const { path, line } = req.query
  openFile({ path, line})
  res.end()
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
var net = require("net")

async function openFile({ path, line }){
  var socket = net.Socket()
  socket.connect(socketAddr);
  let nvim = await attach({ reader: socket, writer: socket})
  await nvim.command(`tabnew +${line} ${path}`)
}

