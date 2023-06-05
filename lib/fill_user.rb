require 'fetch_batch_users'

class FillUser
  def self.run 
    Issue.joins(:user).where("user_id is null or users.avatar_url is null").in_batches(of: 20) do |issues|
      FetchBatchUsers.new(issues, :author, Issue).run if issues.present?
    end

    PullRequest.joins(:user).where("user_id is null or users.avatar_url is null").in_batches(of: 20) do |prs|
      FetchBatchUsers.new(prs, :author, PullRequest).run if prs.present?
    end

    Fork.joins(:user).where("user_id is null or users.avatar_url is null").in_batches(of: 20) do |forks|
      FetchBatchUsers.new(forks, :author, Fork).run if forks.present?
    end
  end
end