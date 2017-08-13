class ChangeUserImageToImageUrl < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :image, :image_url
  end
end
