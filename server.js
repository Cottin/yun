var webpack = require('webpack');
var WebpackDevServer = require('webpack-dev-server');
var config = require('./webpack.config');

var PORT = 3088;

new WebpackDevServer(webpack(config), {
  publicPath: config.output.publicPath,
  hot: true,
	stats: {
		hash: false,
		version: false,
		assets: false,
		cached: false,
		colors: true
	},
	noInfo: false,
	quiet: false,
	historyApiFallback: true
}).listen(PORT, 'localhost', function (err, result) {
  if (err) {
    console.log(err);
  }

  console.log('Listening at localhost:'+PORT);
});
