class CreateDeviceStats < ActiveRecord::Migration[6.1]
  def change
    create_table :device_stats do |t|
      t.bigint :device_id, null: false, index: true
      t.integer :stats, null: false

      t.timestamps
    end
  end
end
