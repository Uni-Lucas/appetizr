class RenameCamelCaseImgs < ActiveRecord::Migration[7.1]
  def change
    rename_column :dishes, :rutaImgPlato, :ruta_img_plato
    rename_column :responses, :rutaImg, :ruta_img
    rename_column :restaurants, :rutaImgPerfil, :ruta_img_perfil
    rename_column :restaurants, :rutaImgFondo, :ruta_img_fondo
    rename_column :reviews, :rutaImg, :ruta_img
    rename_column :users, :rutaImgPerfil, :ruta_img_perfil
  end
end
