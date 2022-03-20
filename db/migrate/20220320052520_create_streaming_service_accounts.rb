class CreateStreamingServiceAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :streaming_service_accounts do |t|
      t.string :name, null: false
      t.string :image_url
      t.bigint :streaming_service_id, null: false
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.datetime :expires_at, null: false
      t.string :uid, null: false

      t.timestamps
    end
  end
end
