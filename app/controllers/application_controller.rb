class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  before_action :ensure_user_authentication
  before_action :set_locale

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  def ensure_user_authentication
    redirect_to login_path unless current_user
  end

  def set_locale
    if current_user && current_user.locale.present?
      I18n.locale = current_user.locale.underscore
    end
  end
end
