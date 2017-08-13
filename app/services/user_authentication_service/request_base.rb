class UserAuthenticationService::RequestBase
   def provider
     raise NoMethodError
   end

   def uid
     raise NoMethodError
   end

   def user_name
     raise NoMethodError
   end

   def user_gender
     raise NoMethodError
   end

   def user_email
     raise NoMethodError
   end

   def user_image_url
     raise NoMethodError
   end

   def user_locale
     raise NoMethodError
   end

   def credentials_token
     raise NoMethodError
   end

   def credentials_expiration
     raise NoMethodError
   end

  def valid?
    raise NoMethodError
  end
end
