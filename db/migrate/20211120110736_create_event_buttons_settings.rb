class CreateEventButtonsSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :event_buttons_settings do |t|
      t.bigint :event_id, null: false
      t.text :content, null: false

      t.timestamps
      t.index :event_id, unique: true
    end
  end
end
