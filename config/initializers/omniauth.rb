OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV.fetch('GOOGLE_CLIENT_ID') { 'DUMMY_GOOGLE_CLIENT_ID' },
    ENV.fetch('GOOGLE_SECRET_ID') { 'DUMMY_GOOGLE_SECRET_ID' },
    {
      client_options:
      {
        ssl: {
          ca_file: Rails.root.join('cacert.pem').to_s
        }
      }
    }

  provider :facebook,
    ENV.fetch('FACEBOOK_CLIENT_ID') { 'DUMMY_FACEBOOK_CLIENT_ID' },
    ENV.fetch('FACEBOOK_SECRET_ID') { 'DUMMY_FACEBOOK_SECRET_ID' }
end
