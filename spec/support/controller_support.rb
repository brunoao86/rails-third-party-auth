module ControllerSupport
  extend ActiveSupport::Concern

  def sign_in
    logged_user = FactoryGirl.create(:user)

    session[:user_id] = logged_user.id
  end
end
