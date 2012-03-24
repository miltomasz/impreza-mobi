# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_impreza-mobi_session',
  :secret      => '80a315f78a87453ec7891367d8c217081039c3a134c746a5d411cc5cca7b0f93ca7770e9695358cdfd1385ea2854fde0adf13dfd0b384b219757c200048ceaa8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
