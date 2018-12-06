module.exports = {
  prompts: {
    frame: {
      type: 'list',
      choices: ['vue', 'none', 'react'],
      default: 0,
      message: 'Which frame do you use?'
    },
    lint: {
      type: 'confirm',
      message: 'Use lint to lint to code?'
    }
  },
  filters: {
    'src/app.js': 'lint',
    'src/app.vue': 'frame === "vue"'
  },
  message: 'Welcome to use webpack and {frame}!'
}
