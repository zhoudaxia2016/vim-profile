{{#frame:react}}import React from 'react'
import ReactDom from 'react-dom'
import App from './app'

ReactDom.render(
  <App/>,
  document.getElementById('root')
)

if (module.hot) {
  module.hot.accept()
}{{/frame:react}}{{#frame:vue}}import Vue from 'vue'
import App from './app.vue'

new Vue({
  el: '#root',
  render: h => h(App)
}){{/frame:vue}}
