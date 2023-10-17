class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, primary_key: :nombre, id: false do |t|
      t.string :nombre
      t.string :contrasegna #codificada
      t.string :rutaImgPerfil
      t.boolean :esAdmin
    end
    
  end
end
