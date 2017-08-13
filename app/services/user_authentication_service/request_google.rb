class UserAuthenticationService::RequestGoogle < UserAuthenticationService::RequestBase
  attr_reader :request_auth

  def initialize(raw_request)
    @request_auth = raw_request.env["omniauth.auth"]
  end

  def provider
    'google'
  end

  def uid
    @uid ||= request_auth.uid
  end

  def user_name
    @user_name ||= request_auth.info.name
  end

  def user_gender
    @user_gender ||= request_auth.extra.raw_info.gender
  end

  def user_email
    @user_email ||= request_auth.info.email
  end

  def raw_image_url
    @raw_image_url ||= request_auth.info.image
  end

  def user_image_url
    "#{raw_image_url}?size=200" if raw_image_url.present?
  end

  def user_locale
    @user_locale ||= request_auth.extra.raw_info.locale
  end

  def credentials_token
    @credentials_token ||= request_auth.credentials.token
  end

  def credentials_expiration
    @credentials_expiration ||= Time.at(request_auth.credentials.expires_at)
  end

  def request_validation_token
    @request_validation_token ||= request_auth.extra.id_info.aud
  end

  def valid?
    request_validation_token === ENV['GOOGLE_CLIENT_ID']
  end
end
