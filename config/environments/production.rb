Friskyfactory::Application.configure do

  config.filter_parameters = [ :password, :password_confirmation ]

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx
  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :warn

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  config.cache_store = :mem_cache_store, 'localhost:11211'

  # Enable serving of images, stylesheets, and javascripts from an asset server
  config.action_controller.asset_host = "http://assets%d.friskyfactory.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = false
  config.ignore_recipient_emailability = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :address              => 'smtp.postmarkapp.com',
      :port                 => 25,
      :domain               => 'friskyfactory.com',
      :user_name            => '3c6bca6d-6cd7-4476-bf7a-a2959f5778c7',
      :password             => '3c6bca6d-6cd7-4476-bf7a-a2959f5778c7',
      :authentication       => 'plain',
      :enable_starttls_auto => true  }

  config.action_mailer.default_url_options = {
    :host => 'friskyfactory.com'
  }

   config.paperclip_defaults = {
    storage: :s3,
    s3_credentials: {
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    },
    s3_permissions: :read_public,
    bucket: ENV["S3_BUCKET_NAME"]
  }

  config.after_initialize { require 'sti' }
end
