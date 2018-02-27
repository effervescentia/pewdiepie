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
    extensions: ['.js', '.elm'],
  },

  plugins: [
    new HtmlPlugin({
      template: 'index.html'
    }),
    new ExtractTextPlugin("styles.css"),
  ],

  module: {
    rules: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      use: [
        'elm-hot-loader',
        {
          loader: 'elm-assets-loader',
          options: {
            module: 'Images',
            tagger: 'Asset'
          }
        },
        'elm-svg-loader',
        {
          loader: 'elm-webpack-loader',
          options: {
            verbose: true,
            warn: true,
            debug: true
          }
        },
      ]
    }, {
      test: /\.css$/,
      use: ExtractTextPlugin.extract({
        fallback: "style-loader",
        use: "css-loader"
      }),
    }, {
      test: /\.svg$/,
      loader: 'raw-loader'
    }, {
      test: /\.(jpe?g|png|gif)$/i,
      loader: 'file-loader',
    }],
  },

  devServer: {
    historyApiFallback: true,
    port: 1337
  }
};