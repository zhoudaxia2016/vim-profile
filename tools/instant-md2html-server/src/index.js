let socket = io('http://localhost:3000')
let app = document.getElementById('app')
document.body.scrollTop = document.body.scrollHeight
socket.on('update', data => {
  if (data.update) {
    app.innerHTML = data.html
    // 调整滚动高度
    document.body.scrollTop = document.body.scrollHeight
  }
})
// 关闭浏览器
socket.on('disconnect', () => {
  window.close()
})
