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

ActiveRecord::Schema.define(version: 2022_01_16_094852) do

  create_table "device_statuses", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.bigint "pbm_session_id", null: false
    t.integer "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_device_statuses_on_device_id"
    t.index ["pbm_session_id"], name: "index_device_statuses_on_pbm_session_id"
  end

  create_table "devices", charset: "utf8mb4", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "name"
    t.string "ip_address"
    t.datetime "last_access_at"
    t.string "hostname"
    t.bigint "user_id"
    t.string "pbm_version"
    t.boolean "enable_pbmenv", default: false
    t.bigint "current_device_status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "unique_key", comment: "自動生成する値"
    t.index ["user_id"], name: "index_devices_on_user_id"
    t.index ["uuid"], name: "index_devices_on_uuid", unique: true
  end

  create_table "events", charset: "utf8mb4", force: :cascade do |t|
    t.text "body"
    t.integer "event_type", null: false
    t.bigint "pbm_session_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pbm_session_id"], name: "index_events_on_pbm_session_id"
    t.index ["updated_at"], name: "index_events_on_updated_at"
  end

  create_table "pbm_jobs", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.integer "action", null: false
    t.string "args", null: false
    t.integer "status", null: false
    t.string "uuid", null: false
    t.text "job_stdout"
    t.text "job_stderr"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uuid"], name: "index_pbm_jobs_on_uuid", unique: true
  end

  create_table "pbm_sessions", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.string "uuid", null: false
    t.string "ip_address"
    t.string "hostname", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uuid"], name: "index_pbm_sessions_on_uuid", unique: true
  end

  create_table "saved_buttons_settings", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.text "content", null: false
    t.string "name"
    t.text "memo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_saved_buttons_settings_on_device_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.boolean "admin", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string "last_login_from_ip_address"
    t.integer "failed_logins_count", default: 0
    t.datetime "lock_expires_at"
    t.string "unlock_token"
    t.string "activation_state"
    t.string "activation_token"
    t.datetime "activation_token_expires_at"
    t.index ["activation_token"], name: "index_users_on_activation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["unlock_token"], name: "index_users_on_unlock_token"
  end

end
