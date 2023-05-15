class CreateJobLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :job_logs do |t|
      t.datetime :started_at
      t.datetime :end_at
      t.string :status 
      t.string :message
      t.string :job_name, default: 'SyncGithub'
      t.index [:started_at, :job_name], unique: true
    end
  end
end
