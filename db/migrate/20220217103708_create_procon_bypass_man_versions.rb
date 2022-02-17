class CreateProconBypassManVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :procon_bypass_man_versions do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
