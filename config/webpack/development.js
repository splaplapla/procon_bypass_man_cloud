process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const { merge } = require('webpack-merge')
const ForkTSCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin");

// console.log(environment.config.resolve.alias)

module.exports = merge(environment.toWebpackConfig(), {
  plugins: [new ForkTSCheckerWebpackPlugin()],
})
