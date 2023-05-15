class SyncRegion 
  def self.sync!
    User.where("location is not null and location <> '' and region is null").limit(200).each do |user|
      region = Geocoder.search(user.location)&.first&.country rescue nil
      if region.present?
        User.where(id: user.id).update(region: region) 
      else
        User.where(id: user.id).update(region: 'N/A') 
      end
    end
  end

  def self.run!
    JobLog.with_log("SyncRegion") do
      self.sync!
    end
  end
end
