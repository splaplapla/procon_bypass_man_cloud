class AddUserIdToSavedButtonsSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :saved_buttons_settings, :user_id, :bigint, null: true
  end
end
