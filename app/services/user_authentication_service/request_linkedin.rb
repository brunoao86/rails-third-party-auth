class UserAuthenticationService::RequestLinkedin < UserAuthenticationService::RequestBase
  attr_reader :request_auth

  def initialize(raw_request)
    @request_auth = raw_request.env["omniauth.auth"]
  end

  def provider
    'linkedin'
  end

  def uid
    @uid ||= request_auth.uid
  end

  def user_name
    @user_name ||= request_auth.info.name
  end

  def user_gender
    # linkedin does not return a gender field
    @user_gender ||= ''
  end

  def user_email
    @user_email ||= request_auth.info.email
  end

  def raw_image_url
    @raw_image_url ||= request_auth.info.picture_url
  end

  def user_image_url
    "#{raw_image_url}" if raw_image_url.present?
  end

  def user_locale
    language = request_auth.extra.raw_info.firstName.preferredLocale.language
    country = request_auth.extra.raw_info.firstName.preferredLocale.country

    @user_locale ||= "#{language}_#{country}"
  end

  def credentials_token
    @credentials_token ||= request_auth.credentials.token
  end

  def credentials_expiration
    @credentials_expiration ||= request_auth.credentials.expires_at
  end

  def valid?
    # FIXME: We do not have the access_token.token to verify anymore
    true
  end
end
