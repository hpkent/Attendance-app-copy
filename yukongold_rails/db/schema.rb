# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170702153741) do

  create_table "attendance_status_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "category_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "order",      limit: 4
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "description", limit: 255
  end

  create_table "location_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "meeting_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "meetings", force: :cascade do |t|
    t.integer  "monastic_id",     limit: 4
    t.integer  "note_id",         limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "sitting_id",      limit: 4
    t.integer  "student_id",      limit: 4
    t.date     "start_date"
    t.datetime "start_time"
    t.integer  "meeting_type_id", limit: 4
  end

  create_table "monastics", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "initials",   limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "note_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "note_type_id", limit: 4
    t.text     "content",      limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "sittings", force: :cascade do |t|
    t.string   "event_title",     limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "note_id",         limit: 255
    t.datetime "updated_at",                  null: false
    t.datetime "created_at",                  null: false
    t.boolean  "no_meeting_flag", limit: 1
  end

  create_table "special_status_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "priority",   limit: 4
  end

  create_table "students", force: :cascade do |t|
    t.string   "first_name",           limit: 255
    t.string   "last_name",            limit: 255
    t.integer  "category_type_id",     limit: 4
    t.date     "acceptance_date"
    t.string   "email",                limit: 255
    t.string   "dietary_restrictions", limit: 255
    t.text     "other",                limit: 65535
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "days_since_last_seen", limit: 4
    t.date     "date_last_seen"
    t.boolean  "bench",                limit: 1
    t.integer  "senority",             limit: 4
  end

  create_table "students_groups", force: :cascade do |t|
    t.integer  "student_id", limit: 4
    t.integer  "group_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "students_sittings", force: :cascade do |t|
    t.integer  "sitting_id",                limit: 4
    t.integer  "student_id",                limit: 4
    t.integer  "attendance_status_type_id", limit: 4
    t.integer  "special_status_type_id",    limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "meeting_id",                limit: 4
    t.boolean  "hatto",                     limit: 1, default: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "access_token",  limit: 255
    t.string   "refresh_token", limit: 255
    t.datetime "expires_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.integer  "role",                   limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
