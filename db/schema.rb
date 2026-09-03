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

ActiveRecord::Schema[8.1].define(version: 2026_09_03_025224) do
  create_table "events", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "end", precision: nil
    t.string "ics_uid", default: -> { "(uuid())" }
    t.string "recurring_uuid"
    t.datetime "start", precision: nil
    t.text "title"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["end"], name: "index_events_on_end"
    t.index ["ics_uid"], name: "index_events_on_ics_uid", unique: true
    t.index ["recurring_uuid"], name: "index_events_on_recurring_uuid"
    t.index ["start"], name: "index_events_on_start"
  end
end
