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

ActiveRecord::Schema[7.0].define(version: 2024_01_22_011342) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "habits", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.text "description"
    t.decimal "overall_progress", precision: 5, scale: 2, default: "0.0"
    t.integer "current_streak", default: 0
    t.integer "record_streak", default: 0
    t.index ["user_id"], name: "index_habits_on_user_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.string "metricable_type", null: false
    t.bigint "metricable_id", null: false
    t.integer "unit", null: false
    t.integer "value", null: false
    t.datetime "measured_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metricable_type", "metricable_id"], name: "index_metrics_on_metricable"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.string "notable_type", null: false
    t.bigint "notable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable"
  end

  create_table "tasks", force: :cascade do |t|
    t.datetime "completed_at"
    t.bigint "habit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["habit_id"], name: "index_tasks_on_habit_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "habits", "users"
  add_foreign_key "tasks", "habits"
end
