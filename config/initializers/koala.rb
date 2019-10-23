Koala.configure do |config|
  config.api_version = ENV.fetch('FACEBOOK_API_VERSION')
  config.app_id      = ENV.fetch('FACEBOOK_CLIENT_ID')
  config.app_secret  = ENV.fetch('FACEBOOK_SECRET_ID')
end
