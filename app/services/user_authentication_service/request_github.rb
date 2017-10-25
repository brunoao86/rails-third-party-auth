class UserAuthenticationService::RequestGithub < UserAuthenticationService::RequestBase
  attr_reader :request_auth, :request_strategy

  def initialize(raw_request)
    @request_auth = raw_request.env["omniauth.auth"]
    @request_strategy = raw_request.env['omniauth.strategy']
  end

  def provider
    'github'
  end

  def uid
    @uid ||= request_auth.uid
  end

  def user_name
    @user_name ||= request_auth.info.name
  end

  def user_gender
    # github doesn't return gender field
    @user_gender ||= ''
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
    # github doesn't return locale field
    @user_gender ||= ''
  end

  def credentials_token
    @credentials_token ||= request_auth.credentials.token
  end

  def credentials_expiration
    @credentials_expiration ||= request_auth.credentials.expires
  end

  def request_validation_token
    @request_validation_token ||= request_strategy.options.client_id
  end

  def valid?
    request_validation_token === ENV['GITHUB_CLIENT_ID']
  end
end
