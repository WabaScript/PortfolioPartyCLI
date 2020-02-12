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

ActiveRecord::Schema.define(version: 2020_02_11_221741) do

  create_table "investments", force: :cascade do |t|
    t.string "symbol"
    t.float "purchase_price"
    t.float "current_price"
    t.string "purchase_date"
    t.integer "portfolio_id"
    t.integer "num_shares"
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "portfolio_name"
    t.float "initial_cash"
    t.float "current_cash"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
  end

end
