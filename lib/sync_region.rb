class SyncRegion 
  def run
    User.where("location is not null and location <> '' and region is null").limit(200).each do |user|
      region = Geocoder.search(user.location)&.first&.country rescue nil
      if region.present?
        User.where(id: user.id).update(region: region) 
      else
        User.where(id: user.id).update(region: 'N/A') 
      end
    end
  end
end
