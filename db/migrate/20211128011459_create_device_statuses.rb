class CreateDeviceStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :device_statuses do |t|
      t.bigint :device_id, null: false, index: true
      t.integer :status, null: false

      t.timestamps
    end
  end
end
