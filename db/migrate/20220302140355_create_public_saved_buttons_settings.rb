class CreatePublicSavedButtonsSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :public_saved_buttons_settings do |t|
      t.bigint :saved_buttons_setting_id, null: false
      t.string :unique_key, null: false
      t.text :memo

      t.timestamps
      t.index :saved_buttons_setting_id, unique: true
      t.index :unique_key, unique: true
    end
  end
end
