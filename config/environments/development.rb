Friskyfactory::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # config.cache_store = :mem_cache_store, 'localhost:11211'
  config.cache_store = :memory_store

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # config.action_controller.asset_host = "http://assets.friskyfactory.localhost:3000"

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
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
      },
      s3_permissions: :public_read,
      bucket: ENV["S3_BUCKET_NAME"])
  end

  config.paperclip_defaults = paperclip_defaults

  config.after_initialize { load 'sti.rb' }
end
