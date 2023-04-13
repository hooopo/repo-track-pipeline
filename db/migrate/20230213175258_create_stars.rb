class CreateStars < ActiveRecord::Migration[7.0]
  def change
    create_table :starred_repos, id: false do |t|
      t.bigint "user_id", null: false
      t.bigint "repo_id", null: false
      t.datetime "starred_at", null: false
      t.index ["user_id", "repo_id"], name: "index_starred_repos_on_user_id_and_repo_id", unique: true
    end
  end
end