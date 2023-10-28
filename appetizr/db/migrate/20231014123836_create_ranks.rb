class CreateRanks < ActiveRecord::Migration[7.1]
  def change
    create_table :ranks, primary_key: [:who, :what], id: false do |t|
      t.string :who
      t.bigint :what
      t.integer :valoracion
      t.timestamps
    end

    add_foreign_key :ranks, :users, column: :who, primary_key: :nombre
    add_foreign_key :ranks, :restaurants, column: :what

    create_table :restaurants_users, id: false do |t|
      t.belongs_to :restaurant
      t.belongs_to :user # puede fallar por esta fk
    end


  end
end
