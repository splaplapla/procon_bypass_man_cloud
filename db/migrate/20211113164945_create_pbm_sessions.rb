class CreatePbmSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :pbm_sessions do |t|
      t.string :ulid, null: false
      t.string :ip_address
      t.string :hostname, null: false
      t.bigint :user_id, null: true, index: true # あとで使う

      t.timestamps
      t.index :ulid, unique: true
    end
  end
end
