class SyncGithub
  def self.run!
    raise("REPO_FULL_NAME env missing, please set it") if ENV["REPO_FULL_NAME"].blank?
    ENV["REPO_FULL_NAME"].split(",").each do |repo_full_name|
      puts "👉 Sync repo #{repo_full_name} info #{ENV['REPO_FULL_NAME']}"
      FetchRepo.new(repo_full_name).run 

      puts "👇 Sync #{repo_full_name} Issues"
      FetchIssues.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} PullRequests"
      FetchPullRequests.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} Forks"
      FetchForks.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} Stars"
      FetchStars.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} user_id attribute"
      FillUser.run

      puts "Done"
    end
  end
end