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

ActiveRecord::Schema[7.0].define(version: 2023_05_05_000021) do
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

