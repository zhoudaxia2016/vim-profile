import Vue from 'vue/dist/vue.js'
import App from './components/App.vue'
new Vue({
  el: '#bpp',
  template: '<app/>',
  components: { App }
})
console.log(1)

document.write(
  '<script src="http://' + (location.host || 'localhost').split(':')[0] +
  ':35729/livereload.js?snipver=1"></' + 'script>'
)
