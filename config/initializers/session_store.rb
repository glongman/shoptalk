# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_shoptalk_session',
  :secret      => '621523c8e6e00e3e9f191769ef41a36edc67773fc43ac0a9cb57faede4ae28370256749b613951defbfbae83c7dcad2eb56d1ef27105db38e810521f48cbc1f5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
