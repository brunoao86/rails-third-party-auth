class User < ApplicationRecord
  validates_presence_of :name, :email

  def presenter
    @presenter ||= UserPresenter.new(self)
  end
end
