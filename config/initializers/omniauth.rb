OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV.fetch('GOOGLE_CLIENT_ID'),
    ENV.fetch('GOOGLE_SECRET_ID'),
    {
      client_options:
      {
        ssl: {
          ca_file: Rails.root.join('cacert.pem').to_s
        }
      }
    }

  facebook_api_version = ENV.fetch('FACEBOOK_API_VERSION')
  provider :facebook,
    ENV.fetch('FACEBOOK_CLIENT_ID'),
    ENV.fetch('FACEBOOK_SECRET_ID'),
    {
      client_options: {
        site: "https://graph.facebook.com/#{facebook_api_version}",
        authorize_url: "https://www.facebook.com/#{facebook_api_version}/dialog/oauth"
      }
    }

  provider :twitter,
    ENV.fetch('TWITTER_CLIENT_ID'),
    ENV.fetch('TWITTER_SECRET_ID')

  provider :linkedin,
    ENV.fetch('LINKEDIN_CLIENT_ID'),
    ENV.fetch('LINKEDIN_SECRET_ID')

  provider :github,
    ENV.fetch('GITHUB_CLIENT_ID'),
    ENV.fetch('GITHUB_SECRET_ID'),
    scope: 'user'
end
