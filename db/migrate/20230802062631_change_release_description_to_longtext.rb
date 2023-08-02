class ChangeReleaseDescriptionToLongtext < ActiveRecord::Migration[7.0]
  def change
    change_column :releases, :description, :longtext
  end
end
