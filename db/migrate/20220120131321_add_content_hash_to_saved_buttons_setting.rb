class AddContentHashToSavedButtonsSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :saved_buttons_settings, :content_hash, :string, null: true
  end
end
