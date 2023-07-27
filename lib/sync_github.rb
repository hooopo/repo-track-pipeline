class SyncGithub
  def self.sync!
    if ENV["REPO_FULL_NAME"].present?
      ENV["REPO_FULL_NAME"].split(",").each do |repo_full_name|
        RepoFullNameConfig.find_or_create_by(full_name: repo_full_name)
      end
    end

    RepoFullNameConfig.all.each do |config|
      repo_full_name = config.full_name
      puts "👉 Sync repo #{repo_full_name} of #{ RepoFullNameConfig.all.map{|c| c.full_name }.join(', ') }"
      FetchRepo.new(repo_full_name).run 

      puts "👇 Sync #{repo_full_name} Issues"
      FetchIssues.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} PullRequests"
      FetchPullRequests.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} Forks"
      FetchForks.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} Stars"
      FetchStars.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} Releases"
      FetchReleases.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} Views"
      FetchViews.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} Clones"
      FetchClones.new(repo_full_name).run

      puts "👇 Sync #{repo_full_name} user_id attribute"
      FillUser.run

      puts "👇 Sync #{repo_full_name} pypi downloads"

      if ENV["PYPI_PACKAGE"].present? && ENV["REPO_FULL_NAME"].split(",").size == 1
        FetchPypiDownloads.new(repo_full_name, ENV["PYPI_PACKAGE"]).run
      end

      puts "Done"
    end
  end

  def self.run!
    JobLog.with_log("SyncGithub") do
      self.sync!
    end
  end
end