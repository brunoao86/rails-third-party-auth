class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def presenter
    @presenter ||= "#{self.class.name}Presenter".constantize.new(self)
  end
end
