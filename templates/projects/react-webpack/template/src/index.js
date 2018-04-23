import React from 'react'
import ReactDom from 'react-dom'
import App from './app.js'

ReactDom.render(
  <App/>,
  document.getElementById('root')
)

if (module.hot) {
  module.hot.accept()
}
