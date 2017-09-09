class UserPresenter < SimpleDelegator
  def initialize(user)
    @user = user

    super(@user)
  end

  def gender
    if @user.gender.present?
      User.human_attribute_name("gender.#{@user.gender}")
    end
  end
end
