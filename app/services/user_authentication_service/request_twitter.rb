
class UserAuthenticationService::RequestTwitter < UserAuthenticationService::RequestBase
  attr_reader :request_auth

  def initialize(raw_request)
    @request_auth = raw_request.env["omniauth.auth"]
  end

  def provider
    'twitter'
  end

  def uid
    @uid ||= request_auth.uid
  end

  def user_name
    @user_name ||= request_auth.info.name
  end

  def user_gender
    # twitter does not return a gender field
    @user_gender ||= ''
  end

  def user_email
    # Twitter must be configured to release email as described in
    # https://developer.twitter.com/en/docs/accounts-and-users/manage-account-settings/api-reference/get-account-verify_credentials#request-a-user-s-email-address
    #
    # TODO If not configured in the twitter app, this field will return nil, which
    # will create an error. Either we can raise an exception about this to inform
    # the developer to adjust their settings or set this to a default value if we
    # receive a nil value
    @user_email ||= request_auth.info.email
  end

  def raw_image_url
    @raw_image_url ||= request_auth.info.image
  end

  def user_image_url
    "#{raw_image_url}?size=200" if raw_image_url.present?
  end

  def user_locale
    @user_locale ||= request_auth.extra.raw_info.lang
  end

  def credentials_token
    @credentials_token ||= request_auth.credentials.token
  end

  def credentials_expiration
    # Twitter access tokens do not expire unless user revokes them, so setting it
    # to a year in the future so their is something to comply with the database schema
    @credentials_expiration ||= Time.now + 31540000
  end

  def request_validation_token
    @request_validation_token ||= request_auth.extra.access_token.consumer.key
  end

  def valid?
    request_validation_token === ENV['TWITTER_CLIENT_ID']
  end
end
