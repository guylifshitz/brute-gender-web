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

ActiveRecord::Schema.define(version: 20161017230311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "word_sources"
    t.integer  "word_frequency_maximum"
    t.integer  "word_score_maximum"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "category_words", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "include_word"
    t.integer  "url_frequency"
    t.integer  "category_ranking"
    t.integer  "word_id"
    t.integer  "category_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "category_words", ["category_id"], name: "index_category_words_on_category_id", using: :btree
  add_index "category_words", ["word_id"], name: "index_category_words_on_word_id", using: :btree

  create_table "level_instances", force: :cascade do |t|
    t.integer  "level_id"
    t.integer  "user_id"
    t.integer  "complete_count"
    t.float    "correct_completion_percent"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "level_instances", ["level_id"], name: "index_level_instances_on_level_id", using: :btree
  add_index "level_instances", ["user_id"], name: "index_level_instances_on_user_id", using: :btree

  create_table "level_words", force: :cascade do |t|
    t.integer  "level_id"
    t.integer  "word_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "level_words", ["level_id"], name: "index_level_words_on_level_id", using: :btree
  add_index "level_words", ["word_id"], name: "index_level_words_on_word_id", using: :btree

  create_table "levels", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "statistics"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "levels", ["category_id"], name: "index_levels_on_category_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "sound"
    t.boolean  "microphone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "word_scores", force: :cascade do |t|
    t.integer  "level_instance_id"
    t.integer  "word_id"
    t.integer  "user_id"
    t.integer  "category_id"
    t.boolean  "correct"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "word_scores", ["category_id"], name: "index_word_scores_on_category_id", using: :btree
  add_index "word_scores", ["level_instance_id"], name: "index_word_scores_on_level_instance_id", using: :btree
  add_index "word_scores", ["user_id"], name: "index_word_scores_on_user_id", using: :btree
  add_index "word_scores", ["word_id"], name: "index_word_scores_on_word_id", using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "word"
    t.string   "word_plural"
    t.string   "definition_en"
    t.string   "definition_fr"
    t.string   "gender"
    t.integer  "frequency"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_foreign_key "category_words", "categories"
  add_foreign_key "category_words", "words"
  add_foreign_key "level_instances", "levels"
  add_foreign_key "level_instances", "users"
  add_foreign_key "level_words", "levels"
  add_foreign_key "level_words", "words"
  add_foreign_key "levels", "categories"
  add_foreign_key "word_scores", "categories"
  add_foreign_key "word_scores", "level_instances"
  add_foreign_key "word_scores", "users"
  add_foreign_key "word_scores", "words"
end
