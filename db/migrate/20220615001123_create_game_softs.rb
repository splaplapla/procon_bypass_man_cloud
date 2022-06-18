class CreateGameSofts < ActiveRecord::Migration[7.0]
  def change
    create_table :game_softs do |t|
      t.string :title, null: false
      t.integer :remote_macro_templates_count, null: false, default: 0

      t.timestamps
    end
  end
end
