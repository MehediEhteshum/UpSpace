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

ActiveRecord::Schema.define(version: 2020_10_09_153012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "avatars", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_avatars_on_user_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.date "day"
    t.integer "price"
    t.integer "status"
    t.bigint "space_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id"], name: "index_calendars_on_space_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favourites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "space_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "context"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "read_at"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "path_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "space_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "sort"
    t.index ["space_id"], name: "index_photos_on_space_id"
  end

  create_table "price_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.decimal "price", precision: 8, scale: 2
    t.integer "price_type_id"
    t.bigint "space_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id"], name: "index_prices_on_space_id"
  end

  create_table "reservations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "space_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.decimal "price", precision: 8, scale: 2
    t.decimal "total", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.datetime "guest_48_hour_reminder_sent_at"
    t.datetime "host_48_hour_reminder_sent_at"
    t.string "price_type"
    t.decimal "term", precision: 8, scale: 2
    t.string "charge_id"
    t.datetime "authorized_at"
    t.datetime "captured_at"
    t.string "source_id"
    t.text "description"
    t.index ["created_at"], name: "index_reservations_on_created_at"
    t.index ["space_id"], name: "index_reservations_on_space_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.integer "star", default: 1
    t.bigint "space_id"
    t.bigint "guest_id"
    t.bigint "host_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "reservation_id"
    t.index ["guest_id"], name: "index_reviews_on_guest_id"
    t.index ["host_id"], name: "index_reviews_on_host_id"
    t.index ["space_id"], name: "index_reviews_on_space_id"
  end

  create_table "settings", force: :cascade do |t|
    t.boolean "enable_sms", default: false, null: false
    t.boolean "enable_email", default: true, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "space_requests", force: :cascade do |t|
    t.integer "user_id"
    t.string "date_request"
    t.text "description"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_request"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "title"
    t.string "listing_type"
    t.string "listing_category"
    t.integer "price"
    t.text "description"
    t.integer "capacity"
    t.string "address"
    t.boolean "is_wifi", default: false, null: false
    t.boolean "is_food", default: false, null: false
    t.boolean "is_accessible", default: false, null: false
    t.string "parking"
    t.boolean "active", default: false, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.integer "instant", default: 0
    t.boolean "is_alcohol", default: false, null: false
    t.boolean "is_catering", default: false, null: false
    t.boolean "is_kitchen", default: false, null: false
    t.boolean "is_ground", default: false, null: false
    t.boolean "is_audio", default: false, null: false
    t.boolean "is_natural", default: false, null: false
    t.boolean "is_byob", default: false, null: false
    t.boolean "is_video", default: false, null: false
    t.string "video_embed"
    t.string "tour_embed"
    t.integer "sqft"
    t.boolean "featured", default: false, null: false
    t.text "availability_text"
    t.index ["user_id"], name: "index_spaces_on_user_id"
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
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fullname"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "provider"
    t.string "uid"
    t.string "image"
    t.string "phone_number"
    t.text "description"
    t.string "pin"
    t.boolean "phone_verified", default: false, null: false
    t.string "stripe_id"
    t.string "merchant_id"
    t.integer "unread", default: 0
    t.string "referral_code"
    t.integer "referred_by_id"
    t.integer "user_type"
    t.boolean "admin", default: false, null: false
    t.boolean "remember_card", default: false, null: false
    t.string "time_zone", default: "EST"
    t.string "found_us"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "avatars", "users"
  add_foreign_key "calendars", "spaces"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "photos", "spaces"
  add_foreign_key "prices", "spaces"
  add_foreign_key "reservations", "spaces"
  add_foreign_key "reservations", "users"
  add_foreign_key "reviews", "spaces"
  add_foreign_key "reviews", "users", column: "guest_id"
  add_foreign_key "reviews", "users", column: "host_id"
  add_foreign_key "settings", "users"
  add_foreign_key "spaces", "users"
end
