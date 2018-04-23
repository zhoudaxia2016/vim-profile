import Greeting from './greeting.js'

window.addEventListener('load', function () {
  ReactDOM.render(
    <Greeting/>,
    document.getElementsByClassName('app')[0]
  )
})
