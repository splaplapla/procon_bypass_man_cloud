// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import Rails from "@rails/ujs"
import $ from 'jquery'
// import "bootstrap"
import { createPopper } from '@popperjs/core';
import "chartkick"
import "Chart.bundle"

window.$ = $
window.jQuery = $

import * as bootstrap from 'bootstrap'
window.bootstrap = bootstrap // FIXME: テンプレートに書いているインラインjsがなくなったら消せる

import "channels"

Rails.start()
import "controllers"
