class CreateStreamingServices < ActiveRecord::Migration[6.1]
  def change
    create_table :streaming_services do |t|
      t.string :name, null: false
      t.bigint :user_id, null: false
      t.integer :service_type, null: false
      t.bigint :remote_macro_group_id, null: true
      t.bigint :device_id, null: true
      t.boolean :enabled, null: true, default: false

      t.timestamps
    end
  end
end
