class CreateResponses < ActiveRecord::Migration[7.1]
  def change

    create_table :reviews do |t|
      t.string :autor
      t.references :reviewable, polymorphic: true
      t.text :contenido
      t.string :rutaImg
      t.timestamps
    end

    add_foreign_key :reviews, :users, column: :autor, primary_key: :nombre

    create_table :responses do |t|
      t.string :autor
      t.references :respondable, polymorphic: true
      t.text :contenido
      t.string :rutaImg
      t.timestamps
    end

    add_foreign_key :responses, :users, column: :autor, primary_key: :nombre

    create_table :reactions, primary_key: [:who, :reactionable_id], id: false do |t|
      t.string :who
      t.references :reactionable, polymorphic: true
      t.string :reaccion
    end

    add_foreign_key :reactions, :users, column: :who, primary_key: :nombre
  end
end
