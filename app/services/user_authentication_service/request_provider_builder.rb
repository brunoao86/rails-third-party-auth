class UserAuthenticationService::RequestProviderBuilder
  def self.build(raw_request)
    request_provider = raw_request['provider']

    if request_provider == 'google_oauth2'
      UserAuthenticationService::RequestGoogle.new(raw_request)
    elsif request_provider == 'facebook'
      UserAuthenticationService::RequestFacebook.new(raw_request)
    end
  end
end
