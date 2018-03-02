const path = require('path');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
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
    extensions: ['.js', '.elm', '.css'],
  },

  plugins: [
    new HtmlPlugin({
      template: 'index.html'
    }),
    new ExtractTextPlugin("styles.css"),
  ],

  module: {
    noParse: /\.elm$/,
    rules: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      use: [
        'elm-hot-loader',
        {
          loader: 'elm-webpack-loader',
          options: {
            verbose: true,
            warn: true,
            debug: true
          }
        }
      ]

    }, {
      test: /\.css$/,
      use: ExtractTextPlugin.extract({
        fallback: "style-loader",
        use: "css-loader"
      }),
    }],
  },

  devServer: {
    historyApiFallback: true,
    port: 1337
  }
};