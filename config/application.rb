require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProconBypassManCloud
  class Application < Rails::Application
    if !ENV['DISABLE_ACTION_CABLE'].present?
      config.action_cable.mount_path = '/websocket'
    end
    config.action_cable.disable_request_forgery_protection = true

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.active_support.cache_format_version = 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Asia/Tokyo"

    config.i18n.default_locale = :ja
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.x.discord_invitation_link = 'https://discord.gg/GjaywxVZHY'
  end
end
