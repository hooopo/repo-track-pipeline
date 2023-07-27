class CreatePypiDownloads < ActiveRecord::Migration[7.0]
  def change
    create_table :pypi_downloads, id: false do |t|
      t.bigint :repo_id, index: true
      t.string :package
      t.string :version
      t.integer :downloads, default: 0
      t.date :date
      t.index [:package, :version, :date], unique: true
    end
    add_column :repos, :total_pypi_downloads, :integer, default: 0
  end
end
