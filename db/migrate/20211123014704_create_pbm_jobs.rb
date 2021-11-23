class CreatePbmJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :pbm_jobs do |t|
      t.integer :action, null: false
      t.string :status, null: false
      t.text :job_stdout
      t.text :job_stderr

      t.timestamps
    end
  end
end
