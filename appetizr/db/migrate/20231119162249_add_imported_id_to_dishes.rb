class AddImportedIdToDishes < ActiveRecord::Migration[7.1]
  def change
    add_column :dishes, :imported_id, :integer, default: nil
  end
end
