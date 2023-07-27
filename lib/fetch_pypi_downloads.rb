require 'http'

class FetchPypiDownloads
  attr_reader :name, :owner
  attr_reader :package, :repo

  def initialize(full_name, package)
    raise "full_name format fail" if full_name.to_s !~ /\//
    @owner, @name = full_name.split("/")
    @repo = Repo.where(owner: owner, name: name).first
    @package = package
  end

  def run 
    url = "https://analytics.pepy.tech/api/v2/projects/#{package}"
    response = HTTP.get(url)

    data = response.parse
   
    if data["total_downloads"].nil?
      puts "no downloads"
    else
      repo.update(total_pypi_downloads: data["total_downloads"])

      attrs = data["downloads"].map do |date, attr|
        attr.map do |version, num|
          {
            repo_id: repo.id,
            date: date,
            version: version,
            downloads: num,
            package: package
          }
        end
      end
      PypiDownload.upsert_all(attrs.flatten)
    end
  end
end
