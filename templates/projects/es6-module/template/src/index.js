{{!frame:none}}import App from './app.js'{{/frame:none}}{{!frame:none}}

window.addEventListener('load', function () {
  {{#frame:react}}ReactDOM.render(
    <App name='Mao'/>,
    document.getElementsByClassName('app')[0]
  ){{/frame:react}}{{#frame:vue}}new Vue({
    el: '.app',
    components: { App }
  }){{/frame:vue}}
}){{/frame:none}}
