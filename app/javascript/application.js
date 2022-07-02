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
import * as Turbo from '@hotwired/turbo';

Turbo.start()

Rails.start()

$(function() { // eslint-disable-line
  $("#global-flash").delay(3000).fadeOut('slow');
})
import "controllers"
