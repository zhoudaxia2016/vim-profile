import App from './app.js'

window.addEventListener('load', function () {
  {{#frame:react}}ReactDOM.render(
    <App/>,
    document.getElementsByClassName('app')[0]
  ){{/frame:react}}{{#frame:vue}}new Vue({
    el: '.app',
    components: { App }
  }){{/frame:vue}}
})
