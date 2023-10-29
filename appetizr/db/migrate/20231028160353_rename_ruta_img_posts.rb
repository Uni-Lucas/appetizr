class RenameRutaImgPosts < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :rutaImg, :ruta_img
  end
end
