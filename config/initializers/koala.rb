Koala.configure do |config|
  config.api_version = 'v2.10'
  config.app_id = ENV.fetch('FACEBOOK_CLIENT_ID') { 'DUMMY_FACEBOOK_CLIENT_ID' }
  config.app_secret = ENV.fetch('FACEBOOK_SECRET_ID') { 'DUMMY_FACEBOOK_SECRET_ID' }
end
