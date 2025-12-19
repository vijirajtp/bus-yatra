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

ActiveRecord::Schema[8.1].define(version: 2025_12_19_181743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "status"
    t.integer "total_amount"
    t.bigint "trip_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["trip_id"], name: "index_bookings_on_trip_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "buses", force: :cascade do |t|
    t.integer "bus_type"
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "operator_id", null: false
    t.datetime "updated_at", null: false
    t.index ["operator_id"], name: "index_buses_on_operator_id"
  end

  create_table "operators", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_operators_on_user_id"
  end

  create_table "routes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "from_city"
    t.string "to_city"
    t.datetime "updated_at", null: false
  end

  create_table "seat_holds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.bigint "trip_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["trip_id"], name: "index_seat_holds_on_trip_id"
    t.index ["user_id"], name: "index_seat_holds_on_user_id"
  end

  create_table "seats", force: :cascade do |t|
    t.bigint "bus_id", null: false
    t.datetime "created_at", null: false
    t.integer "seat_column"
    t.string "seat_number"
    t.integer "seat_row"
    t.datetime "updated_at", null: false
    t.index ["bus_id"], name: "index_seats_on_bus_id"
  end

  create_table "trip_seats", force: :cascade do |t|
    t.integer "booking_id"
    t.datetime "created_at", null: false
    t.integer "seat_hold_id"
    t.bigint "seat_id", null: false
    t.integer "status"
    t.bigint "trip_id", null: false
    t.datetime "updated_at", null: false
    t.index ["seat_id"], name: "index_trip_seats_on_seat_id"
    t.index ["trip_id"], name: "index_trip_seats_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.bigint "bus_id", null: false
    t.datetime "created_at", null: false
    t.bigint "operator_id", null: false
    t.integer "price"
    t.float "rating"
    t.bigint "route_id", null: false
    t.date "travel_date"
    t.datetime "updated_at", null: false
    t.index ["bus_id"], name: "index_trips_on_bus_id"
    t.index ["operator_id"], name: "index_trips_on_operator_id"
    t.index ["route_id"], name: "index_trips_on_route_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "address"
    t.string "city"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.string "phone_number"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 2, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.string "state"
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "bookings", "trips"
  add_foreign_key "bookings", "users"
  add_foreign_key "buses", "operators"
  add_foreign_key "operators", "users"
  add_foreign_key "seat_holds", "trips"
  add_foreign_key "seat_holds", "users"
  add_foreign_key "seats", "buses"
  add_foreign_key "trip_seats", "seats"
  add_foreign_key "trip_seats", "trips"
  add_foreign_key "trips", "buses"
  add_foreign_key "trips", "operators"
  add_foreign_key "trips", "routes"
end
