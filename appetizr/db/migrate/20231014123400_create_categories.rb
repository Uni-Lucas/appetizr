class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories, primary_key: :nombre, id: false do |t|
      t.string :nombre
      t.timestamps
    end

    create_table :restaurants do |t|
      t.string :categoria
      t.string :nombre
      t.string :rutaImgPerfil
      t.string :rutaImgFondo
      t.string :direccion
      t.string :telefono
      t.string :horario
    end

    add_foreign_key :restaurants, :categories, column: :categoria, primary_key: :nombre
    create_table :posts do |t|
      t.string :categoria
      t.string :autor
      t.text :contenido
      t.string :rutaImg
      t.timestamps
    end

    add_foreign_key :posts, :categories, column: :categoria, primary_key: :nombre
    add_foreign_key :posts, :users, column: :autor, primary_key: :nombre

    create_table :dishes do |t|
      t.references :restaurant, foreign_key: true
      t.string :nombre
      t.string :rutaImgPlato
      t.text :descripcion
      t.float :precio
    end
  end
end
