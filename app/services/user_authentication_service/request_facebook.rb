class UserAuthenticationService::RequestFacebook < UserAuthenticationService::RequestBase
  def initialize(raw_request)
    facebook_request = raw_request.env["omniauth.auth"]
    strategy         = raw_request.env['omniauth.strategy']

    @provider                 = 'facebook'
    @credentials_token        = facebook_request.credentials.token
    @request_validation_token = strategy.options.client_id
    @uid                      = facebook_request.uid
    @user_name                = facebook_request.info.name
    @user_gender              = extra_information['gender']
    @user_email               = facebook_request.info.email
    @user_image               = facebook_request.info.image
    @user_locale              = extra_information['locale']
    @credentials_expiration   = Time.at(facebook_request.credentials.expires_at)
  end

  def valid?
    @request_validation_token === ENV['FACEBOOK_CLIENT_ID']
  end

  private

  def extra_information
    if valid?
      @extra_information ||= koala_facebook_api_service
        .get_object("me?fields=gender,locale")
    else
      {}
    end
  end

  def koala_facebook_api_service
    Koala::Facebook::API.new(@credentials_token)
  end
end
