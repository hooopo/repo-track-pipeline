class SyncRegion 
  def run
    User.where("location is not null and location <> '' and region is null").limit(5000).each do |user|
      region = Geocoder.search(user.location)&.first&.country rescue nil
      if region.present?
        User.where(id: user.id).update_all(region: region) 
      else
        User.where(id: user.id).update_all(region: 'N/A') 
      end
    end
  end
end
