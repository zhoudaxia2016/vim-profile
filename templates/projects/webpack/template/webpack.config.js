const path = require('path')
const webpack = require('webpack')

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'index.js',
    path: path.resolve(__dirname, 'dist')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        use: ['babel-loader', 'eslint-loader'],
	enforce: 'pre',
	exclude: /node_modules/
      }{{#frame:vue}}, {
        test: /\.vue$/,
        use: 'vue-loader'
      }{{/frame:vue}}
    ]
  },
  devtool: 'eval-source-map',
  plugins: [
    new webpack.NamedModulesPlugin(),
    new webpack.HotModuleReplacementPlugin(),
  ],
  devServer: {
    contentBase: './dist',
    hot: true,
    port: 6060
  }
}
