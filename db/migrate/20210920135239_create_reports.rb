class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.text :body
      t.string :report_type, null: false
      t.string :ip_address
      t.string :hostname, null: false
      t.bigint :user_id, null: true # あとで使う

      t.timestamps
    end
  end
end
