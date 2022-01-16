class AddUniqueKeyToDevices < ActiveRecord::Migration[6.1]
  def change
    add_column :devices, :unique_key, :string, comment: "自動生成する値"
  end
end
