class UpdateReactionTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :reactions
    create_table :reactions do |t|
      t.string :who
      t.references :reactionable, polymorphic: true
      t.string :reaccion
    end
    add_foreign_key :reactions, :users, column: :who, primary_key: :nombre
    add_index :reactions, [:who, :reactionable_id, :reactionable_type], unique: true
  end
end
