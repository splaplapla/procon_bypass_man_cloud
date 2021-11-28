class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.string :uuid, null: false
      t.string :name
      t.string :ip_address
      t.datetime :last_access_at
      t.string :hostname, null: false
      t.bigint :user_id, null: true, index: true # あとで使う
      t.string :pbm_version, null: true
      t.boolean :enable_pbmenv, null: true, default: false
      t.bigint :current_device_status_id, null: true

      t.timestamps
      t.index :uuid, unique: true
    end
  end
end
