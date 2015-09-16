var path = require('path');
var webpack = require('webpack');

module.exports = {
  devtool: 'eval',
  // devtool: 'source-map',
  rootPath: __dirname,
  entry: [
    'webpack-dev-server/client?http://localhost:3000',
    'webpack/hot/dev-server',
    './src/demo/main'
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/static/'
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  ],
  resolve: {
    extensions: ['', '.js', '.coffee']
  },
  module: {
    loaders: [{
      test: /\.coffee?$/,
      loaders: ['react-hot', 'coffee-loader'],
      include: path.join(__dirname, 'src')
    },
    {
      test: /\.coffee?$/,
      loaders: ['coffee-loader'],
      exclude: path.join(__dirname, 'src')
      // include does not seem to work with npm link
      // include: path.join(__dirname, 'node_modules')
      // https://github.com/webpack/webpack/issues/784
    }]
  }
};
