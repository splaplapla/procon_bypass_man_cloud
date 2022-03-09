class CreateRemoteMacroGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :remote_macro_groups do |t|
      t.bigint :user_id, null: false
      t.string :name
      t.text :memo

      t.timestamps
    end
  end
end
