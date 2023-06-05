class FetchBatchUsers

  attr_reader :items, :logins, :klass, :field
  def initialize(items, field, klass)
    @items = items
    @klass = klass
    @field = field
    @logins = items.map { |item| item.send(field) }.compact.uniq
  end

  def query
    fragments = logins.map do |login|
      <<~USER
        #{normalize_login(login)}: user(login: "#{login}") {
          ...UserFragment
        }
      USER
    end.join("\n")

    <<~GQL
      query {
        rateLimit {
          limit
          cost
          remaining
          resetAt
        }
 
        #{fragments}
      }

      fragment UserFragment on User {
        databaseId
        name
        login
        company
        location
        twitterUsername
        avatarUrl
        bio
        createdAt
        updatedAt
        
        following {
          totalCount
        }
        followers {
          totalCount
        }
      }

    GQL
  end

  def get_attrs(data)
    logins.map do |login|
      base = data.dig("data", normalize_login(login))
      next if base.nil?
      {
        id: base.dig("databaseId"),
        login: base["login"],
        company: base["company"],
        twitter_username: base["twitterUsername"],
        avatar_url: base["avatarUrl"],
        location: base["location"],
        created_at: base["createdAt"],
        updated_at: base["updatedAt"],
        followers_count: base.dig("followers", "totalCount"),
        following_count: base.dig("following", "totalCount")
      }
    end.compact
  end

  def run
    return if logins.blank?
    response = HTTP.post("https://api.github.com/graphql",
      headers: {
        "Authorization": "Bearer #{ENV['ACCESS_TOKEN']}",
        "Content-Type": "application/json"
      },
      json: { query: query }
    )

    data = response.parse
    
    attrs = get_attrs(data)
    attrs.each do |attr|
      klass.where(field => attr[:login]).update_all(user_id: attr[:id])
    end
    User.upsert_all(attrs) if attrs.present?
  end

  def normalize_login(login)
    str = login.gsub("-", "_")
    str = "_" + str if str.start_with?(/\d/)
    str
  end

end