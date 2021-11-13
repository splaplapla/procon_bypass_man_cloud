class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.text :body
      t.string :event_type, null: false
      t.string :pbm_session_id

      t.timestamps
    end
    add_index :events, :pbm_session_id
    add_index :events, :updated_at
  end
end
