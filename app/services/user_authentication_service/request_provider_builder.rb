class UserAuthenticationService::RequestProviderBuilder
  def self.build(raw_request)
    request_provider = raw_request['provider']

    if request_provider == 'google_oauth2'
      RequestGoogle.new(raw_request.env["omniauth.auth"])
    end
  end
end
