# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_25_073310) do
  create_table "clones", id: false, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "timestamp"
    t.bigint "repo_id"
    t.integer "count"
    t.integer "uniques"
    t.index ["repo_id", "timestamp"], name: "index_clones_on_repo_id_and_timestamp", unique: true
  end

  create_table "forks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "parent"
    t.string "author"
    t.bigint "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author"], name: "index_forks_on_author"
    t.index ["created_at"], name: "index_forks_on_created_at"
    t.index ["parent"], name: "index_forks_on_parent"
    t.index ["updated_at"], name: "index_forks_on_updated_at"
  end

  create_table "issues", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "repo_id"
    t.boolean "locked"
    t.string "title"
    t.boolean "closed"
    t.datetime "closed_at"
    t.string "state"
    t.integer "number"
    t.string "author"
    t.bigint "user_id"
    t.string "author_association"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author"], name: "index_issues_on_author"
    t.index ["created_at"], name: "index_issues_on_created_at"
    t.index ["updated_at"], name: "index_issues_on_updated_at"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "job_logs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "end_at"
    t.string "status"
    t.string "message"
    t.string "job_name", default: "SyncGithub"
    t.index ["started_at", "job_name"], name: "index_job_logs_on_started_at_and_job_name", unique: true
  end

  create_table "labels", id: false, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.bigint "item_id"
    t.string "item_type"
    t.bigint "repo_id"
    t.index ["item_id", "item_type", "name"], name: "index_labels_on_item_id_and_item_type_and_name", unique: true
  end

  create_table "pull_requests", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "repo_id"
    t.boolean "locked"
    t.string "title"
    t.boolean "closed"
    t.datetime "closed_at"
    t.string "state"
    t.integer "number"
    t.string "author"
    t.bigint "user_id"
    t.string "author_association"
    t.boolean "is_draft"
    t.integer "additions", default: 0
    t.integer "deletions", default: 0
    t.datetime "merged_at"
    t.string "merged_by"
    t.integer "changed_files", default: 0
    t.boolean "merged"
    t.integer "comments_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author"], name: "index_pull_requests_on_author"
    t.index ["created_at"], name: "index_pull_requests_on_created_at"
    t.index ["updated_at"], name: "index_pull_requests_on_updated_at"
  end

  create_table "releases", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "repo_id"
    t.string "name"
    t.string "tag_name"
    t.string "author"
    t.text "description"
    t.datetime "published_at"
    t.boolean "is_draft", default: false
  end

  create_table "repo_full_name_configs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "full_name"
    t.index ["full_name"], name: "index_repo_full_name_configs_on_full_name", unique: true
  end

  create_table "repos", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
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
    t.string "last_issue_cursor"
    t.string "last_star_cursor"
    t.string "last_pr_cursor"
    t.string "last_fork_cursor"
    t.text "open_graph_image_url"
    t.string "owner_avatar_url"
    t.string "last_release_cursor"
  end

  create_table "starred_repos", id: false, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "repo_id", null: false
    t.datetime "starred_at", null: false
    t.index ["user_id", "repo_id"], name: "index_starred_repos_on_user_id_and_repo_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "login", null: false
    t.string "company"
    t.string "location"
    t.string "twitter_username"
    t.integer "followers_count", default: 0
    t.integer "following_count", default: 0
    t.string "region"
    t.string "created_at", null: false
    t.string "updated_at", null: false
    t.string "avatar_url"
  end

  create_table "views", id: false, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "timestamp"
    t.bigint "repo_id"
    t.integer "count"
    t.integer "uniques"
    t.index ["repo_id", "timestamp"], name: "index_views_on_repo_id_and_timestamp", unique: true
  end

end
