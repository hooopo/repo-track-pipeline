class CreateRepos < ActiveRecord::Migration[7.0]
  def change
    create_table :repos do |t|
      t.string "name"
      t.string "owner"
      t.bigint "user_id"
      t.string "license"
      t.boolean "is_private"
      t.integer "disk_usage"
      t.string "language"
      t.text "description"
      t.boolean "is_fork"
      t.bigint "parent_id"
      t.integer "fork_count"
      t.integer "stargazer_count"
      t.datetime "pushed_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "is_in_organization", default: false
      t.string :last_issue_cursor
      t.string :last_star_cursor 
      t.string :last_pr_cursor
      t.string :last_fork_cursor
    end
  end
end