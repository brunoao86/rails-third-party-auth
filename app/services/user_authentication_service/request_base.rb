class UserAuthenticationService::RequestBase
  attr_reader :provider, :uid, :user_name, :user_gender, :user_email, :user_image,
              :user_locale, :credentials_token, :credentials_expiration

  def valid?
    raise NoMethodError
  end
end
