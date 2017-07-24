class AddComplementaryInformationToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email, :string
    add_column :users, :image, :string
    add_column :users, :gender, :string
    add_column :users, :locale, :string
  end
end
