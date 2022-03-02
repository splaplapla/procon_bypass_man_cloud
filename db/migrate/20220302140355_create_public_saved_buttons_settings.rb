class CreatePublicSavedButtonsSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :public_saved_buttons_settings do |t|
      t.bigint :saved_buttons_setting_id, null: false
      t.text :memo

      t.timestamps
      t.index :saved_buttons_setting_id, unique: true
    end
  end
end
