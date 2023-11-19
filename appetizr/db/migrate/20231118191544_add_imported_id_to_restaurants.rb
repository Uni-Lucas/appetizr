class AddImportedIdToRestaurants < ActiveRecord::Migration[7.1]
  def change
    add_column :restaurants, :imported_id, :int
  end
end
