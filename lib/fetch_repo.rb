require 'http'

class FetchRepo 
  attr_reader :name, :owner

  def initialize(full_name)
    raise "full_name format fail" if full_name.to_s !~ /\//
    @owner, @name = full_name.split("/")
  end

  def query 
    q = <<~GQL
      query {
        repository(name: "#{name}", owner: "#{owner}") {
          databaseId
          name
          isFork
          pushedAt
          isInOrganization
          isPrivate
          diskUsage
          licenseInfo {
            name
          }
          primaryLanguage {
            name
          }
          owner {
            login
          }
          parent {
            databaseId
          }
          openGraphImageUrl
          description
          forkCount
          stargazerCount
          createdAt
          updatedAt
          repositoryTopics(first: 100) {
            edges {
              node {
                topic {
                  id
                  name
                } 
                
              }
            }
          }
        }
      }
    GQL
  end

  def get_attrs(data)
    base = data.dig("data", "repository")
    {
      id: base.dig("databaseId"),
      is_fork: base["isFork"],
      pushed_at: base["pushedAt"],
      is_in_organization: base["isInOrganization"],
      is_private: base["isPrivate"],
      disk_usage: base["diskUsage"],
      open_graph_image_url: base["openGraphImageUrl"],
      description: base["description"],
      stargazer_count: base["stargazerCount"],
      fork_count: base["forkCount"],
      name: base["name"],
      owner: base.dig("owner", "login"),
      language: base.dig("primaryLanguage", "name"),
      license: base.dig("licenseInfo", "name"),
      parent_id: base.dig("parent", "databaseId"),
      created_at: base["createdAt"],
      updated_at: base["updatedAt"]
    }
  end

  def run 
    response = HTTP.post("https://api.github.com/graphql",
      headers: {
        "Authorization": "Bearer #{ENV['ACCESS_TOKEN']}",
        "Content-Type": "application/json"
      },
      json: { query: query }
    )

    data = response.parse
    attrs = get_attrs(data)
    repo = Repo.upsert(attrs)
    repo
  end
end
