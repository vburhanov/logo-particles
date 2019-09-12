const merge = require('webpack-merge');
const common = require('./common.js');

module.exports = merge(common, {
	mode: 'development',
	devtool: 'inline-source-map',
	devServer: {
		contentBase: './static',
		host: '127.0.0.1'
	}
});
