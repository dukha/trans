Translate::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = true
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_files = false
  #Compress JavaScript and CSS
  config.assets.compress = true
   # Compress JavaScripts and CSS
   config.assets.js_compressor = :uglifier
  # Don't fallback to assets pipeline
  config.assets.compile = false
  # Generate digests for assets URLs
config.assets.digest = true
  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  # this is foir devise. Must be edited for production
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true
  
  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  #rails 4.2 and higher Keep prod log level as info
  config.log_level = :info
  
  config.action_mailer.mailgun_settings = {
        api_key: Rails.application.secrets.mailgun_api_key,#"key-47120298e8c9c31b076e5245655e62c7", #'<mailgun api key>',
        domain: Rails.application.secrets.mailgun_domain#"sandboxa89c6db3f73e4ad6b3377c7bb91dbeb1.mailgun.org" #'<mailgun domain>'
  }
end
