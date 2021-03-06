require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Valiantdb
  class Application < Rails::Application
    config.middleware.use Rack::Deflater
    config.middleware.use Rack::Attack
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # config.exceptions_app = self.routes
    # config.assets.enabled = true
    # config.assets.paths << "#{Rails}/vendor/assets/fonts"
    # config.active_record.raise_in_transactional_callbacks = true
    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL',
      'X-XSS-Protection' => '1; mode=block',
      'X-Content-Type-Options' => 'nosniff',
      'Public-Key-Pins' => 'pin-sha256=VCNF4Yh7vvOsHccjTlvCe8DGiRII0SWeaff7fe4S9gs='
    }
    config.public_file_server.headers = { 'Cache-Control' => 'public, max-age=604800' }
  end
end
