class RemoveDeviceIdFromSavedButtonsSetting < ActiveRecord::Migration[6.1]
  def change
    remove_column :saved_buttons_settings, :device_id, :bigint, null: true
  end
end
