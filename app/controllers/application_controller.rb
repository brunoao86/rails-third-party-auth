class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  before_action :ensure_user_authentication

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  def ensure_user_authentication
    redirect_to login_path unless current_user
  end
end
