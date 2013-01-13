Friskyfactory::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.

  # Log to standout for Unicorn
  config.logger = Logger.new STDOUT

  # CACHING

  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # config.cache_store = :mem_cache_store, 'localhost:11211'
  config.cache_store = :memory_store

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # ASSETS

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.friskyfactory.localhost:3000"

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  # config.assets.compile = false

  # Generate digests for assets URLs
  # config.assets.digest = false

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += [ "jquery-1_6_4.js", "jquery-1_7_2.js", "jquery.tools-1_2_6.tiny.min" ]
  # config.assets.precompile += [ "layouts/admin/index.css", "layouts/admin/index.js" ]
  # config.assets.precompile += [ "layouts/community/index.css", "layouts/community/index.js" ]
  # config.assets.precompile += [ "layouts/inbox/index.css", "layouts/inbox/index.js" ]
  # config.assets.precompile += [ "layouts/personage/index.css", "layouts/personage/index.js" ]
  # config.assets.precompile += [ "layouts/rollcall/index.css", "layouts/rollcall/index.js" ]
  # config.assets.precompile += [ "layouts/welcome/index.css", "layouts/welcome/index.js" ]


  # Raise exception on mass assignment protection for Active Record models
  # config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # MAILER

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  # config.action_mailer.delivery_method = :test
  # config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.dummy_email = 'michael@michaelbamford.com'
  config.ignore_recipient_emailability = true

  config.action_mailer.smtp_settings = {
    :address              => 'smtp.postmarkapp.com',
    :port                 => 25,
    :domain               => 'friskyfactory.com',
    :user_name            => '3c6bca6d-6cd7-4476-bf7a-a2959f5778c7',
    :password             => '3c6bca6d-6cd7-4476-bf7a-a2959f5778c7',
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }

  config.action_mailer.default_url_options = {
    :host => 'friskyfactory.localhost',
    :port => 3000
  }

  paperclip_defaults = { command_path: "/usr/local/bin/" }

  if ENV["FRIENDFACTORY_USE_S3"] == "true"
    paperclip_defaults.merge!(
      storage: :s3,
      s3_credentials: {
        access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
        s3_headers: { 'Cache-Control' => 'max-age=315576000', 'Expires' => 10.years.from_now.httpdate },
      },
      s3_permissions: :public_read,
      bucket: ENV["S3_BUCKET_NAME"])
  end

  config.paperclip_defaults = paperclip_defaults

  config.after_initialize { load 'sti.rb' }

  config.active_record.schema_format = :sql

end
