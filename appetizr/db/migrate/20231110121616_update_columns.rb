class UpdateColumns < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :asOwner
    add_column :posts, :restaurant_id, :bigint
  end
end
