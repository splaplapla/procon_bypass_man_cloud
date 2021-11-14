class CreatePbmSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :pbm_sessions do |t|
      t.bigint :device_id, null: false
      t.string :uuid, null: false
      t.string :ip_address
      t.string :hostname, null: false

      t.timestamps
      t.index :uuid, unique: true
    end
  end
end
