const path = require('path')

module.exports = {
  resolve: {
    alias: {
      // https://github.com/RaiseTech-team01/reservation_app/commit/53702020677bddddf0560f7622b95ea4b3e06cb9 を参考に定義したけど同じようには動かなかった
      // https://github.com/rails/webpacker/issues/986
      '@': path.resolve(__dirname, '..', '..', 'app/javascript/packs'),
      '@setting_editor': path.resolve(__dirname, '..', '..', 'app/javascript/packs/setting_editor'),
    }
  }
}
