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

ActiveRecord::Schema.define(version: 2020_10_20_180306) do

  create_table "bills", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "issue_id"
  end

  create_table "congress_members", force: :cascade do |t|
    t.string "name"
    t.string "party"
    t.string "state"
    t.string "title"
  end

  create_table "donations", force: :cascade do |t|
    t.integer "amount"
    t.integer "congress_member_id"
    t.integer "issue_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "name"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "congress_member_id"
    t.integer "bill_id"
    t.boolean "vote"
  end

end
