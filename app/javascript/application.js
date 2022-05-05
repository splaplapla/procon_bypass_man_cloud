// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import Rails from "@rails/ujs"
import $ from 'jquery'
// import "bootstrap"
import { createPopper } from '@popperjs/core';

window.$ = $
window.jQuery = $

import * as bootstrap from 'bootstrap'
window.bootstrap = bootstrap

import "channels"

Rails.start()

$(function() { // eslint-disable-line
  // tooltip()とかくとエラーになるので、、、
  // $('[data-bs-toggle="tooltip"]').tooltip(); // eslint-disable-line
  const elem = document.querySelector('[data-bs-toggle="tooltip"]')
  if(elem) { createPopper(elem, {}); }

  $("#global-flash").delay(3000).fadeOut('slow');
})
