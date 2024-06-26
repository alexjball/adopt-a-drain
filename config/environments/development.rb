# frozen_string_literal: true

options = Rack::Server.new.options

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # asset host
  config.action_controller.asset_host = "http://#{options[:Host]}:#{options[:Port]}"
  config.action_mailer.asset_host = config.action_controller.asset_host

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = {host: 'localhost:3000'}

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # For Mailcatcher
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
end

# from adopt-a-drain-savannah AND https://www.leemunroe.com/send-automated-email-ruby-rails-mailgun/
ActionMailer::Base.smtp_settings = {
  authentication: :plain,
  address: ENV['MAILSERVER_HOST'],
  port: '587',
  domain: ENV['MAILSERVER_DOMAIN'],
  user_name: ENV['MAILSERVER_USERNAME'],
  password: ENV['MAILSERVER_PASSWORD'],
}
