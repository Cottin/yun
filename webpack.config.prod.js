var path = require('path');
var webpack = require('webpack');

module.exports = {
  devtool: 'cheap-module-source-map',
  entry: [
    './src/yun'
  ],
  output: {
    path: path.join(__dirname, 'lib'),
    filename: 'yun-ui-kit.js',
    library: 'yun-ui-kit',
    libraryTarget: 'umd',
    umdNamedDefine: true
  },
  externals: ['radium'],
  plugins: [
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.DefinePlugin({
      'process.env': {
        'NODE_ENV': JSON.stringify('production')
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        warnings: false
      }
    })
  ],
  resolve: {
    extensions: ['', '.js', '.coffee'],
  },
  module: {
    loaders: [
    {
      test: /\.coffee?$/,
      loaders: ['babel', 'coffee-loader'],
      include: path.join(__dirname, 'src'),
    },
    {
      test: /\.css$/,
      loader: 'style!css-loader?modules&importLoaders=1&localIdentName=[name]__[local]___[hash:base64:5]!postcss-loader' 
    }
    ]
  }
};
