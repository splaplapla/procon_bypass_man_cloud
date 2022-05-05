// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import Rails from "@rails/ujs"
import $ from 'jquery'
// import "bootstrap"
import * as bootstrap from 'bootstrap'
window.bootstrap = bootstrap
import "popper"

window.$ = $
window.jQuery = $

import "channels"

Rails.start()


$(function() { // eslint-disable-line
  $('[data-bs-toggle="tooltip"]').tooltip(); // eslint-disable-line

  $("#global-flash").delay(3000).fadeOut('slow');
})
