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

ActiveRecord::Schema.define(version: 20141019145302) do

  create_table "asteks", force: true do |t|
    t.string   "login"
    t.string   "name"
    t.integer  "family_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "best_of_days", force: true do |t|
    t.date     "day"
    t.integer  "pedago_id"
    t.string   "commentary", default: ""
    t.string   "first"
    t.string   "second"
    t.string   "third"
    t.string   "fourth"
    t.string   "fifth"
    t.string   "sixth"
    t.string   "seventh"
    t.string   "eighth"
    t.string   "ninth"
    t.string   "tenth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "families", force: true do |t|
    t.string   "name"
    t.string   "motto"
    t.string   "room"
    t.integer  "methodology_score",  default: 0
    t.integer  "organization_score", default: 0
    t.integer  "technical_score",    default: 0
    t.integer  "total_score",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grades_imports", force: true do |t|
    t.date     "date"
    t.integer  "norme_tolerance",  default: 100
    t.integer  "minimal_exercise"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exam_colle",       default: false
  end

  create_table "negative_point_family_relationships", force: true do |t|
    t.integer  "negative_point_id"
    t.integer  "number",            default: 1
    t.integer  "family_id"
    t.integer  "pedago_id"
    t.integer  "astek_id"
    t.integer  "grades_import_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "negative_points", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "category"
    t.integer  "points"
    t.integer  "mult",        default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pedagos", force: true do |t|
    t.string   "login"
    t.string   "name"
    t.integer  "family_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positive_point_student_relationships", force: true do |t|
    t.integer  "positive_point_id"
    t.integer  "best_of_day_id"
    t.integer  "grades_import_id"
    t.integer  "student_id"
    t.integer  "pedago_id"
    t.integer  "astek_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "multiplier",        default: 1
  end

  create_table "positive_points", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "category"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.string   "login"
    t.string   "name"
    t.integer  "family_id"
    t.integer  "methodology_score",  default: 0
    t.integer  "organization_score", default: 0
    t.integer  "technical_score",    default: 0
    t.integer  "total_score",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
