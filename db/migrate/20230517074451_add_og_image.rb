class AddOgImage < ActiveRecord::Migration[7.0]
  def change
    add_column :repos, :open_graph_image_url, :text
  end
end