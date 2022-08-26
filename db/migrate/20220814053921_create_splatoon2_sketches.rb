class CreateSplatoon2Sketches < ActiveRecord::Migration[7.0]
  def change
    create_table :splatoon2_sketches do |t|
      t.bigint :user_id, null: false, index: true
      t.string :name, null: false
      t.text :encoded_image, null: false
      t.integer :binary_threshold, null: true
      t.text :crop_data, null: true

      t.timestamps
    end
  end
end
