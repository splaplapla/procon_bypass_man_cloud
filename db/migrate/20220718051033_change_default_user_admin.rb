class ChangeDefaultUserAdmin < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :admin, :boolean, default: false
  end

  def down
    change_column :users, :admin, :boolean, default: true
  end
end
