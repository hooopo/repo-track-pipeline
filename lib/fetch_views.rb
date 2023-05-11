require 'http'

class FetchViews 
  attr_reader :name, :owner

  def initialize(full_name)
    raise "full_name format fail" if full_name.to_s !~ /\//
    @owner, @name = full_name.split("/")
    @repo = Repo.where(owner: owner, name: name).first
  end

  def run 
    response = HTTP.get("https://api.github.com/repos/#{owner}/#{name}/traffic/views",
      headers: {
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "Authorization": "Bearer #{ENV['ACCESS_TOKEN']}",
        "Content-Type": "application/json"
      }
    )

    data = response.parse

    if data["message"]
      puts "Must have push access to repository: #{data["documentation_url"]}"
    else
      attrs = data["views"].map do |view|
        {
          repo_id: @repo.id,
          timestamp: view["timestamp"],
          count: view["count"],
          uniques: view["uniques"]
        }
      end
      View.upsert_all(attrs)
    end
  end
end
