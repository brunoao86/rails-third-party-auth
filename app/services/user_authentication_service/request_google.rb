class UserAuthenticationService::RequestGoogle
  attr_reader :provider, :uid, :user_name, :user_gender, :user_email, :user_image,
              :user_locale, :credentials_token, :credentials_expiration

  def initialize(google_request)
    @provider                 = 'google'
    @uid                      = google_request.uid
    @user_name                = google_request.info.name
    @user_gender              = google_request.extra.raw_info.gender
    @user_email               = google_request.info.email
    @user_image               = google_request.info.image
    @user_locale              = google_request.extra.raw_info.locale
    @credentials_token        = google_request.credentials.token
    @credentials_expiration   = Time.at(google_request.credentials.expires_at)
    @request_validation_token = google_request.extra.id_info.aud
  end

  def valid?
    @request_validation_token === ENV['GOOGLE_CLIENT_ID']
  end
end
