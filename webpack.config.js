const path = require('path');
const HtmlPlugin = require('html-webpack-plugin');

module.exports = {
  entry: {
    app: './src/index.js',
  },

  output: {
    path: path.resolve('dist'),
    filename: '[name].js'
  },

  resolve: {
    extensions: ['.js', '.elm'],
  },

  plugins: [
    new HtmlPlugin({
      template: 'index.html'
    }),
  ],

  module: {
    noParse: /\.elm$/,
    rules: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      loader: 'elm-webpack-loader',
      options: {
        verbose: true,
        warn: true,
        debug: true
      }
    }],
  },

  devServer: {
    historyApiFallback: true,
    port: 1337
  }
};