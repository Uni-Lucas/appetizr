class CreateAppetizrDbModels < ActiveRecord::Migration[7.1]
  def change
    create_table :appetizr_db_models do |t|

      t.timestamps
    end
  end
end
