// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"

Rails.start()
ActiveStorage.start()

$(function() { // eslint-disable-line
  $('[data-bs-toggle="tooltip"]').tooltip(); // eslint-disable-line
})

import $ from 'jquery'
window.$ = $
