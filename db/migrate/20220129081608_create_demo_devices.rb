class CreateDemoDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :demo_devices do |t|
      t.bigint :device_id, null: false

      t.timestamps
      t.index :device_id, unique: true
    end
  end
end
