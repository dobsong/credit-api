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

ActiveRecord::Schema[8.1].define(version: 2026_01_29_000003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bibliography_references", force: :cascade do |t|
    t.string "authors"
    t.string "citation", null: false
    t.datetime "created_at", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.integer "year"
    t.index ["citation"], name: "index_bibliography_references_on_citation", unique: true
  end

  create_table "project_plans", force: :cascade do |t|
    t.text "approach"
    t.text "costings"
    t.datetime "created_at", null: false
    t.text "data"
    t.text "ethics"
    t.boolean "has_started", default: false, null: false
    t.text "laymans_summary"
    t.text "platform"
    t.boolean "previous_engagement", default: false, null: false
    t.text "stakeholder_analysis"
    t.text "support_materials"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "user", null: false
    t.text "vision"
    t.index ["user"], name: "index_project_plans_on_user", unique: true
  end

  create_table "reading_lists", force: :cascade do |t|
    t.bigint "bibliography_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user", null: false
    t.index ["bibliography_id"], name: "index_reading_lists_on_bibliography_id"
    t.index ["user", "bibliography_id"], name: "index_reading_lists_on_user_and_bibliography_id", unique: true
  end

  add_foreign_key "reading_lists", "bibliography_references", column: "bibliography_id"
end
