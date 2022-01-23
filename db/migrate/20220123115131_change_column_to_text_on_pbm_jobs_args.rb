class ChangeColumnToTextOnPbmJobsArgs < ActiveRecord::Migration[6.1]
  def up
    change_column :pbm_jobs, :args, :text
  end

  def down
    change_column :pbm_jobs, :args, :string
  end
end
