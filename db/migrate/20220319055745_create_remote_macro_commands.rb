class CreateRemoteMacroCommands < ActiveRecord::Migration[6.1]
  def change
    create_table :remote_macro_commands do |t|
      t.bigint :remote_macro_id, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
