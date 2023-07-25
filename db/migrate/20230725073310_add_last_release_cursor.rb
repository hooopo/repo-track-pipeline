class AddLastReleaseCursor < ActiveRecord::Migration[7.0]
  def change
    add_column :repos, :last_release_cursor, :string
  end
end