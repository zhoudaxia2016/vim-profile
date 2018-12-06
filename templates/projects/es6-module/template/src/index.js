{{#if_eq frame none}}{{#else}}
import App from './app.js'

{{/if_eq}}
window.addEventListener('load', function () {
  {{#if_eq frame react}}
  ReactDOM.render(
    <App name='Mao'/>,
    document.getElementById('app')
  )
  {{/if_eq}}
  {{#if_eq frame vue}}
  new Vue({
    el: '#app',
    render: h => h(App)
  })
  {{/if_eq}}
})
