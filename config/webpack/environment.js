const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
module.exports = environment

environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: ['popper.js', 'default']
  })
)
module.exports = environment

const customConfig = require('./custom')
environment.config.merge(customConfig)
