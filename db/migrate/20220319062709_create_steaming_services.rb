class CreateSteamingServices < ActiveRecord::Migration[6.1]
  def change
    create_table :steaming_services do |t|
      t.string :name, null: false
      t.bigint :user_id, null: false
      t.integer :service_type, null: false
      t.bigint :remote_macro_group_id, null: false
      t.bigint :device_id, null: false

      t.timestamps
    end
  end
end
