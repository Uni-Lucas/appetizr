class AddColumnImageToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :ruta_img, :string
  end
end
