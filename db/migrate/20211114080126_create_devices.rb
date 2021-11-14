class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :ip_address
      t.string :hostname, null: false
      t.bigint :user_id, null: true, index: true # あとで使う

      t.timestamps
    end
  end
end
