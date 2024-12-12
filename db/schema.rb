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

ActiveRecord::Schema[7.0].define(version: 2024_12_12_012425) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "postgres_books", force: :cascade do |t|
    t.string "title", null: false
    t.string "author", null: false
    t.text "description"
    t.string "genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "postgres_reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.integer "rating", null: false
    t.text "comment", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_postgres_reviews_on_book_id"
    t.index ["user_id"], name: "index_postgres_reviews_on_user_id"
  end

  create_table "postgres_users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "preferences", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_postgres_users_on_email", unique: true
  end

  add_foreign_key "postgres_reviews", "postgres_books", column: "book_id"
  add_foreign_key "postgres_reviews", "postgres_users", column: "user_id"
end
