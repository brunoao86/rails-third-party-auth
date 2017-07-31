class UserAuthenticationService::RequestFacebook
  attr_reader :provider, :uid, :user_name, :user_gender, :user_email, :user_image,
              :user_locale, :credentials_token, :credentials_expiration

  def initialize(raw_request)
    facebook_request = raw_request.env["omniauth.auth"]
    strategy         = raw_request.env['omniauth.strategy']

    @provider                 = 'facebook'
    @uid                      = facebook_request.uid
    @user_name                = facebook_request.info.name
    # @user_gender              = facebook_request.extra.raw_info.gender
    @user_email               = facebook_request.info.email
    @user_image               = facebook_request.info.image
    # @user_locale              = facebook_request.extra.raw_info.locale
    @credentials_token        = facebook_request.credentials.token
    @credentials_expiration   = Time.at(facebook_request.credentials.expires_at)
    @request_validation_token = strategy.options.client_id
  end

  def valid?
    @request_validation_token === ENV['FACEBOOK_CLIENT_ID']
  end
end
