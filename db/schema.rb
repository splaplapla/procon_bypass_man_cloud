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

ActiveRecord::Schema[7.0].define(version: 2022_08_14_053921) do
  create_table "demo_devices", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_demo_devices_on_device_id", unique: true
  end

  create_table "device_statuses", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.bigint "pbm_session_id", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_device_statuses_on_device_id"
    t.index ["pbm_session_id"], name: "index_device_statuses_on_pbm_session_id"
  end

  create_table "devices", charset: "utf8mb4", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "name"
    t.string "ip_address"
    t.datetime "last_access_at", precision: nil
    t.string "hostname"
    t.bigint "user_id"
    t.string "pbm_version"
    t.boolean "enable_pbmenv", default: false
    t.bigint "current_device_status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unique_key", comment: "自動生成する値"
    t.index ["user_id"], name: "index_devices_on_user_id"
    t.index ["uuid"], name: "index_devices_on_uuid", unique: true
  end

  create_table "events", charset: "utf8mb4", force: :cascade do |t|
    t.text "body"
    t.integer "event_type", null: false
    t.bigint "pbm_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pbm_session_id"], name: "index_events_on_pbm_session_id"
    t.index ["updated_at"], name: "index_events_on_updated_at"
  end

  create_table "game_softs", charset: "utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.integer "remote_macro_templates_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pbm_jobs", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.integer "action", null: false
    t.text "args", null: false
    t.integer "status", null: false
    t.string "uuid", null: false
    t.text "job_stdout"
    t.text "job_stderr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_pbm_jobs_on_uuid", unique: true
  end

  create_table "pbm_remote_macro_jobs", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.string "steps", null: false
    t.string "name", null: false
    t.string "uuid", null: false
    t.integer "status", null: false
    t.text "job_stdout"
    t.text "job_stderr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_pbm_remote_macro_jobs_on_uuid", unique: true
  end

  create_table "pbm_sessions", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.string "uuid", null: false
    t.string "ip_address"
    t.string "hostname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_pbm_sessions_on_uuid", unique: true
  end

  create_table "procon_bypass_man_versions", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "public_saved_buttons_settings", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "saved_buttons_setting_id", null: false
    t.string "unique_key", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["saved_buttons_setting_id"], name: "index_public_saved_buttons_settings_on_saved_buttons_setting_id", unique: true
    t.index ["unique_key"], name: "index_public_saved_buttons_settings_on_unique_key", unique: true
  end

  create_table "remote_macro_groups", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remote_macro_templates", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "game_soft_id", null: false
    t.string "title", null: false
    t.string "steps", null: false
    t.text "description"
    t.string "youtube_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_soft_id"], name: "index_remote_macro_templates_on_game_soft_id"
  end

  create_table "remote_macros", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "remote_macro_group_id", null: false
    t.string "name"
    t.text "memo"
    t.string "steps", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saved_buttons_settings", charset: "utf8mb4", force: :cascade do |t|
    t.text "content", null: false
    t.string "name"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_hash"
    t.bigint "user_id"
  end

  create_table "splatoon2_sketches", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "encoded_image", null: false
    t.integer "binary_threshold", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_splatoon2_sketches_on_user_id"
  end

  create_table "streaming_service_accounts", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "image_url"
    t.bigint "streaming_service_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.string "uid", null: false
    t.datetime "monitors_at", precision: nil
    t.text "cached_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_streaming_service_accounts_on_access_token", unique: true
    t.index ["refresh_token"], name: "index_streaming_service_accounts_on_refresh_token", unique: true
    t.index ["streaming_service_id", "uid"], name: "index_streaming_service_id_uid", unique: true
    t.index ["streaming_service_id"], name: "index_streaming_service_accounts_on_streaming_service_id", unique: true
  end

  create_table "streaming_services", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.integer "service_type", null: false
    t.bigint "remote_macro_group_id"
    t.bigint "device_id"
    t.boolean "enabled", default: false
    t.string "unique_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_key"], name: "index_streaming_services_on_unique_key", unique: true
  end

  create_table "taggings", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at", precision: nil
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at", precision: nil
    t.datetime "reset_password_email_sent_at", precision: nil
    t.integer "access_count_to_reset_password_page", default: 0
    t.datetime "last_login_at", precision: nil
    t.datetime "last_logout_at", precision: nil
    t.datetime "last_activity_at", precision: nil
    t.string "last_login_from_ip_address"
    t.integer "failed_logins_count", default: 0
    t.datetime "lock_expires_at", precision: nil
    t.string "unlock_token"
    t.string "activation_state"
    t.string "activation_token"
    t.datetime "activation_token_expires_at", precision: nil
    t.integer "plan", default: 0, null: false
    t.index ["activation_token"], name: "index_users_on_activation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["unlock_token"], name: "index_users_on_unlock_token"
  end

  add_foreign_key "taggings", "tags"
end
