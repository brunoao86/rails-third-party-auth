class UserAuthenticationService
  class InvalidRequest < StandardError; end

  attr_reader :request_provider

  def initialize(raw_request)
    @request_provider = RequestProviderBuilder.build(raw_request)
  end

  def user
    raise InvalidRequest unless request_provider.valid?

    @user ||= User.where(provider: request_provider.provider,
                         uid: request_provider.uid).first_or_initialize
  end

  def authenticate!
    user.tap do |user|
      user.provider         = request_provider.provider
      user.uid              = request_provider.uid
      user.name             = request_provider.user_name
      user.gender           = request_provider.user_gender
      user.email            = request_provider.user_email
      user.image_url        = request_provider.user_image_url
      user.locale           = request_provider.user_locale
      user.oauth_token      = request_provider.credentials_token
      user.oauth_expires_at = request_provider.credentials_expiration

      if request_provider.user_image_url
        user.image = web_image_reader_service.image_base64
      end

      user.save!
    end
  end

  private

  def web_image_reader_service
    WebImageReaderService.new(request_provider.user_image_url)
  end
end
