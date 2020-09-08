# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_08_074518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "name"
    t.bigint "question_id"
    t.boolean "correct", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "badges", force: :cascade do |t|
    t.integer "level"
    t.integer "min_points"
    t.string "name"
    t.string "one_liner"
    t.string "color"
    t.string "badge_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coin_codes", force: :cascade do |t|
    t.string "coupon_code"
    t.float "amount"
    t.integer "limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.string "uid", null: false
    t.string "provider", null: false
    t.integer "user_id"
    t.index ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "notification_tokens", force: :cascade do |t|
    t.bigint "user_id"
    t.string "value"
    t.index ["user_id"], name: "index_notification_tokens_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "time"
    t.integer "channel"
    t.integer "reason"
    t.integer "status"
    t.string "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", default: 0
  end

  create_table "redeemed_rewards", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "rewards_sponsor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rewards_sponsor_id"], name: "index_redeemed_rewards_on_rewards_sponsor_id"
    t.index ["user_id"], name: "index_redeemed_rewards_on_user_id"
  end

  create_table "referrals", force: :cascade do |t|
    t.string "code"
    t.float "amount"
    t.integer "referrals_count", default: 0
    t.float "referrals_amount", default: 0.0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rewards_sponsors", force: :cascade do |t|
    t.string "company_name"
    t.string "offer_name"
    t.text "terms_and_conditions"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "coins"
    t.string "coupon_code"
    t.decimal "offer_amount", precision: 8, scale: 2
    t.bigint "category_id"
    t.string "brand_logo"
    t.integer "reward_type", default: 0
    t.string "currency_type", default: "$"
    t.index ["category_id"], name: "index_rewards_sponsors_on_category_id"
    t.index ["user_id"], name: "index_rewards_sponsors_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "session_type"
    t.integer "status"
    t.integer "rewards", default: 0
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_ping_time", null: false
    t.index ["status"], name: "index_sessions_on_status"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_questions_answers", force: :cascade do |t|
    t.bigint "question_id"
    t.bigint "answer_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_user_questions_answers_on_answer_id"
    t.index ["question_id"], name: "index_user_questions_answers_on_question_id"
    t.index ["user_id"], name: "index_user_questions_answers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mobile"
    t.string "country_code"
    t.string "name"
    t.decimal "wallet_balance", default: "0.0"
    t.string "auth_token"
    t.string "profile_picture"
    t.boolean "email_auth_validations", default: true
    t.integer "company_id"
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lng", precision: 10, scale: 6
    t.string "city"
    t.string "country_name"
    t.integer "home_duration_in_seconds", default: 0, null: false
    t.integer "away_duration_in_seconds", default: 0, null: false
    t.integer "role", default: 0
    t.string "company"
    t.string "designation"
    t.integer "total_earned_coins", default: 0
    t.jsonb "coin_codes"
    t.boolean "is_redeemed", default: false
    t.index ["auth_token"], name: "index_users_on_auth_token"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["lat", "lng"], name: "index_users_on_lat_and_lng"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["wallet_balance"], name: "index_users_on_wallet_balance", order: :desc
  end

  create_table "wallet_transactions", force: :cascade do |t|
    t.string "description"
    t.decimal "amount", precision: 10, scale: 2
    t.integer "transaction_type"
    t.datetime "timestamp"
    t.decimal "closing_balance", precision: 10, scale: 2
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gateway_transaction_id"
    t.index ["user_id"], name: "index_wallet_transactions_on_user_id"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "redeemed_rewards", "rewards_sponsors"
  add_foreign_key "redeemed_rewards", "users"
  add_foreign_key "rewards_sponsors", "categories"
  add_foreign_key "rewards_sponsors", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_questions_answers", "answers"
  add_foreign_key "user_questions_answers", "questions"
  add_foreign_key "user_questions_answers", "users"
end
