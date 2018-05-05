{{#frame:react}}function App (props) {
  return (
    <div>Hello {props.name}</div>
  )
}{{/frame:react}}{{#frame:vue}}let App = {
  template: '<div>Hello {%{name}%}</div>',
  data () {
    return { name: 'Mao' }
  }
}{{/frame:vue}}

export default App
