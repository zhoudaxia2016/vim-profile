module.exports = {
  prompts: {
    frame: {
      type: 'list',
      choices: ['none', 'vue', 'react'],
      default: 0
    },
    name: {
      type: 'input',
      message: 'Input the project\'s name:'
    },
    refresh: {
      type: 'list',
      choices: [
        {
          name: 'Use polling?',
          value: 'poll'
        }, {
          value: 'socketio',
          name: 'Use socket.io'
        },
      ],
      default: 0
    }
  },
  filters: {
    dist: 'frame === "react"',
    'src/app.js': 'frame !== "none"',
    '.babelrc': 'frame === "react"'
  },
  message: "Welcome to use {frame}!"
}
