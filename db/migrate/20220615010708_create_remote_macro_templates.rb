class CreateRemoteMacroTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :remote_macro_templates do |t|
      t.bigint :game_soft_id, null: false, index: true
      t.string :title, null: false
      t.string  :steps , null: false
      t.text :description
      t.string :youtube_url

      t.timestamps
    end
  end
end
