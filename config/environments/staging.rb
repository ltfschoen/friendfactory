Friskyfactory::Application.configure do

  # Log to standout for Unicorn
  config.logger = Logger.new STDOUT

  config.filter_parameters = [ :password, :password_confirmation ]

  # Log to standout for Unicorn
  config.logger = Logger.new STDOUT

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  config.cache_store = :mem_cache_store, 'localhost:11211', { :namespace => 'staging' }

  # ASSETS

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets%d.friskyfactory.com"

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  # config.assets.compile = false
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true

  config.ignore_recipient_emailability = true

  config.dummy_email = 'michael@michaelbamford.com'

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => 'smtp.postmarkapp.com',
    :port                 => 25,
    :domain               => 'friskyfactory.com',
    :user_name            => '3c6bca6d-6cd7-4476-bf7a-a2959f5778c7',
    :password             => '3c6bca6d-6cd7-4476-bf7a-a2959f5778c7',
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }

  config.action_mailer.default_url_options = { :host => 'staging.friskyfactory.com' }

  config.redis_url = ENV["REDIS_URL"]
  config.redis_database = ENV["REDIS_DATABASE"]

  config.paperclip_defaults = {
    storage: :s3,
    s3_credentials: {
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      s3_headers: { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate },
    },
    s3_permissions: :public_read,
    bucket: ENV["S3_BUCKET_NAME"]
  }

  config.after_initialize { require 'sti' }
end
