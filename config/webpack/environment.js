const { environment } = require('@rails/webpacker')
module.exports = environment

const customConfig = require('./custom')
environment.config.merge(customConfig)
