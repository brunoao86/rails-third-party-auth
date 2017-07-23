class UserAuthenticationService::RequestGoogle
  attr_reader :provider, :uid, :user_name, :credentials_token, :credentials_expiration

  def initialize(google_request)
    @provider                 = 'google'
    @uid                      = google_request.uid
    @user_name                = google_request.info.name
    @credentials_token        = google_request.credentials.token
    @credentials_expiration   = Time.at(google_request.credentials.expires_at)
    @request_validation_token = google_request.extra.id_info.aud
  end

  def valid?
    @request_validation_token === ENV['GOOGLE_CLIENT_ID']
  end
end
