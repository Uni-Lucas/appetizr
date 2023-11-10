class UpdateRestaurantsUsersUser < ActiveRecord::Migration[7.1]
  def change
    change_column(:restaurants_users, :user_id, :string)
    add_foreign_key :restaurants_users, :users, column: :user_id, primary_key: :nombre 
    add_column :posts, :asOwner, :boolean, default: false
  end
end
