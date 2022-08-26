class ChangePbmRemoteMacroJobsStepsToText < ActiveRecord::Migration[7.0]
  def up
    change_column :pbm_remote_macro_jobs, :steps, :text
  end

  def down
    change_column :pbm_remote_macro_jobs, :steps, :string
  end
end
