class CreateSavedButtonsSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :saved_buttons_settings do |t|
      t.bigint :device_id, null: false, index: true
      t.text :content, null: false
      t.string :name
      t.text :memo

      t.timestamps
    end
  end
end
