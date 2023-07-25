require 'http'

class FetchReleases
  attr_reader :name, :owner, :repo

  def initialize(full_name)
    raise "full_name format fail" if full_name.to_s !~ /\//
    @owner, @name = full_name.split("/")
    @repo = Repo.where(owner: owner, name: name).first
    raise "repo not found" if @repo.nil?
  end

  def query(cusor)
    if cusor 
      after = %Q|, after: "#{cusor}"|
    else
      after = ''
    end
    <<~GQL
      query {
        rateLimit {
          limit
          cost
          remaining
          resetAt
        }
        repository(name: "#{name}", owner: "#{owner}") {
          releases(first: 100, orderBy: {field: CREATED_AT, direction: ASC} #{after}) {
            pageInfo {
              endCursor
              hasNextPage
            }
            edges {
              node {
                databaseId
                name
                tagName
                author {
                  login
                }
                publishedAt
                description
                isDraft
              }
            }
          }
        }
      }
    GQL
  end

  def run
    cusor = repo.last_release_cursor
    remaining_count ||= 5000
    is_has_next_page = true
    loop do 
      # puts cusor 
      # puts remaining_count
      # puts is_has_next_page

      data = fetch_data(cusor)
      attrs = get_attr_list(data)
      if attrs.blank?
        puts "All releases synced successed"
        break
      else
        Release.upsert_all(attrs) if attrs.present?
      end
      cusor = end_cusor(data)
      
      remaining_count = remaining(data)
      is_has_next_page = has_next_page(data)
      repo.update(last_release_cursor: cusor) if cusor.present?
      if remaining_count == 1
        puts "You do not have enough remaining ratelimit, please try it after an hour."
        break
      end

      if not is_has_next_page
        puts "All releases synced successed"
        break
      end
    end
  end

  def fetch_data(cusor)
    q = query(cusor)
    puts "- Sync releases with cusor: #{cusor}"
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
    data.dig("data", "repository", "releases", "pageInfo", "endCursor")
  end

  def has_next_page(data)
    data.dig("data", "repository", "releases", "pageInfo", "hasNextPage")
  end

  def get_attr_list(data)
    edges = data.dig("data", "repository", "releases", "edges")
    if edges.nil?
      puts data["errors"]
      raise "GitHub API issue, please try again later"
    end
    edges.map do |edge|
      hash = edge["node"]
      {
        repo_id: repo.id,
        id: hash["databaseId"],
        published_at: hash["publishedAt"],
        name: hash["name"],
        author: hash.dig("author", "login"),
        tag_name: hash["tagName"],
        description: hash["description"],
        is_draft: hash["isDraft"]
      }
    end
  end
end
