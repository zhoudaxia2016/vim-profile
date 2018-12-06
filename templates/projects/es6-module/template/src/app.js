{{#if_eq frame react}}
function App (props) {
  return (
    <div>Hello {props.name}</div>
  )
}
{{/if_eq}}
{{#if_eq frame vue}}
let App = {
  template: '<div>Hello {%{name}%}</div>',
  data () {
    return { name: 'Mao' }
  }
}
{{/if_eq}}

export default App
