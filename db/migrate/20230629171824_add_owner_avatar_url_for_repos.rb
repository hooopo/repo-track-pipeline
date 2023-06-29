class AddOwnerAvatarUrlForRepos < ActiveRecord::Migration[7.0]
  def change
    add_column :repos, :owner_avatar_url, :string
  end
end
