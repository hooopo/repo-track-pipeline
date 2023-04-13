require 'http'

class FetchForks
  attr_reader :name, :owner, :repo

  def initialize(full_name)
    raise "full_name format fail" if full_name.to_s !~ /\//
    @owner, @name = full_name.split("/")
    @repo = Repo.where(owner: owner, name: name).first
    raise "repo not found" if @repo.nil?
  end

  def query(cusor)
    if cusor 
      <<~GQL
        query {
          rateLimit {
            limit
            cost
            remaining
            resetAt
          }
          repository(name: "#{name}", owner: "#{owner}") {
            forks(first: 100, after: "#{cusor}", orderBy: {field: UPDATED_AT, direction: ASC}) {
              pageInfo {
                endCursor
                hasNextPage
              }
              edges {
                node {
                  databaseId
                  parent {
                    databaseId
                  }
                  name
                  owner {
                    login
                  }
                  createdAt
                  updatedAt 
                }
              }
            }
          }
        }
      GQL
    else
      <<~GQL
        query {
          rateLimit {
            limit
            cost
            remaining
            resetAt
          }
          repository(name: "#{name}", owner: "#{owner}") {
            forks(first: 100, orderBy: {field: UPDATED_AT, direction: ASC}) {
              pageInfo {
                endCursor
                hasNextPage
              }
              edges {
                node {
                  databaseId
                  parent {
                    databaseId
                  }
                  name
                  owner {
                    login
                  }
                  createdAt
                  updatedAt 
                }
              }
            }
          }
        }
      GQL
    end
  end

  def run
    cusor = repo.last_fork_cursor
    remaining_count ||= 5000
    is_has_next_page = true
    loop do 
      # puts cusor 
      # puts remaining_count
      # puts is_has_next_page

      data = fetch_data(cusor)
      attrs = get_attr_list(data)
      if attrs.blank?
        puts "All forks synced successed"
        break
      else
        Fork.upsert_all(attrs)
      end
      cusor = end_cusor(data)
      
      remaining_count = remaining(data)
      is_has_next_page = has_next_page(data)
      repo.update(last_fork_cursor: cusor) if cusor.present?
      if remaining_count == 1
        puts "You do not have enough remaining ratelimit, please try it after an hour."
        break
      end

      if not is_has_next_page
        puts "All forks synced successed"
        break
      end
    end
  end

  def fetch_data(cusor)
    q = query(cusor)
    puts "- Sync forks with cusor: #{cusor}"
    response = HTTP.post("https://api.github.com/graphql",
      headers: {
        "Authorization": "Bearer #{ENV['ACCESS_TOKEN']}",
        "Content-Type": "application/json"
      },
      json: { query: q }
    )
    response.parse
  end

  def remaining(data)
    data.dig("data", "rateLimit", "remaining")
  end

  def end_cusor(data)
    data.dig("data", "repository", "forks", "pageInfo", "endCursor")
  end

  def has_next_page(data)
    data.dig("data", "repository", "forks", "pageInfo", "hasNextPage")
  end

  def get_attr_list(data)
    edges = data.dig("data", "repository", "forks", "edges")
    if edges.nil?
      puts data["errors"]
      raise "GitHubb API issue, please try again later"
    end
    edges.map do |edge|
      hash = edge["node"]
      {
        id: hash["databaseId"],
        parent: repo.id,
        created_at: hash["createdAt"],
        updated_at: hash["updatedAt"],
        name: hash["name"],
        author: hash.dig("owner", "login"),
      }
    end
  end
end
