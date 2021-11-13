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

ActiveRecord::Schema.define(version: 2021_11_13_154819) do

  create_table "events", charset: "utf8mb4", force: :cascade do |t|
    t.text "body"
    t.string "event_type", null: false
    t.string "session_id"
    t.string "ip_address"
    t.string "hostname", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_events_on_created_at"
    t.index ["session_id"], name: "index_events_on_session_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

end
