class CreateRemoteMacros < ActiveRecord::Migration[6.1]
  def change
    create_table :remote_macros do |t|
      t.bigint :remote_macro_group_id, null: false
      t.string :name
      t.text :memo
      t.string :steps, null: false

      t.timestamps
    end
  end
end
