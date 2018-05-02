{{#frame:react}}function App (name) {
  return (
    <div>Hello {name}</div>
  )
}{{/frame:react}}{{#frame:vue}}let App = {
  template: '<div>Hello {%{name}%}</div>',
  data: {
    name: 'Mao'
  }
}{{/frame:vue}}

export default App
