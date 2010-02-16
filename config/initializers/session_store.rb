# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_friskyfactory_session',
  :secret      => '808a676729c7c0afd9c052b7ffdb2caa8e6a23db6b747e16931addd7f506e137c4c7113ecdfe18134e2398a3d00f65136317627c703ba18eed2a66ea983e05d1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
