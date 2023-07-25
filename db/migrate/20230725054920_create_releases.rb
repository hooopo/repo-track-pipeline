class CreateReleases < ActiveRecord::Migration[7.0]
  def change
    create_table :releases, id: false do |t|
      t.bigint :id, primary_key: true
      t.bigint :repo_id
      t.string :name
      t.string :tag_name
      t.string :author
      t.text :description
      t.datetime :published_at
      t.boolean :is_draft, default: false
    end
  end
end