class SessionsController < ApplicationController
  skip_before_action :ensure_user_authentication, only: [:new, :create]

  def new; end

  def create
    user = user_authentication_service.authenticate!

    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def user_authentication_service
    UserAuthenticationService.new(request)
  end
end
