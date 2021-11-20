class CreateEventButtonsSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :event_buttons_settings do |t|
      t.bigint :event_id, null: false, index: true
      t.text :content

      t.timestamps
    end
  end
end
