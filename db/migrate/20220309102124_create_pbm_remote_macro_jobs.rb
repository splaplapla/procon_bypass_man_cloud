class CreatePbmRemoteMacroJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :pbm_remote_macro_jobs do |t|
      t.bigint :device_id, null: false
      t.string :steps, null: false
      t.string :name, null: false
      t.string :uuid, null: false
      t.integer :status, null: false
      t.text :job_stdout
      t.text :job_stderr

      t.index :uuid, unique: true
      t.timestamps
    end
  end
end
