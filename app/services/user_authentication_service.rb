class UserAuthenticationService
  attr_reader :request_provider

  def initialize(raw_request)
    @request_provider = RequestProviderBuilder.build(raw_request)
  end

  def user
    raise 'Invalid Request' unless request_provider.valid?

    @user ||= User.where(provider: request_provider.provider,
                         uid: request_provider.uid).first_or_initialize
  end

  def authenticate!
    user.tap do |user|
      user.provider         = request_provider.provider
      user.uid              = request_provider.uid
      user.name             = request_provider.user_name
      user.oauth_token      = request_provider.credentials_token
      user.oauth_expires_at = request_provider.credentials_expiration
      user.save!
    end
  end
end
