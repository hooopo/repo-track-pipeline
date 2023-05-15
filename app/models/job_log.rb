class JobLog < ApplicationRecord
  def self.with_log(job_name)
    started_at = Time.now
    begin
      yield
    rescue => e
      status = 'failed'
      raise e
    else
      status = 'success'
    ensure
      self.create(
        started_at: started_at,
        end_at: Time.now,
        status: status,
        job_name: job_name,
        message: e&.message || 'OK'
      )
    end
  end


end