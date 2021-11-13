class AddEventsIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :events, :session_id
    add_index :events, :user_id
    add_index :events, :created_at
  end
end
