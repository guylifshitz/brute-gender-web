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

ActiveRecord::Schema.define(version: 20161001213251) do

  create_table "level_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "level_instances", force: :cascade do |t|
    t.integer  "level_id",                   limit: 4
    t.integer  "user_id",                    limit: 4
    t.integer  "complete_count",             limit: 4
    t.float    "correct_completion_percent", limit: 24
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "level_instances", ["level_id"], name: "index_level_instances_on_level_id", using: :btree
  add_index "level_instances", ["user_id"], name: "index_level_instances_on_user_id", using: :btree

  create_table "level_words", force: :cascade do |t|
    t.integer  "level_id",   limit: 4
    t.integer  "word_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "level_words", ["level_id"], name: "index_level_words_on_level_id", using: :btree
  add_index "level_words", ["word_id"], name: "index_level_words_on_word_id", using: :btree

  create_table "levels", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "description",       limit: 255
    t.string   "statistics",        limit: 255
    t.integer  "level_category_id", limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "levels", ["level_category_id"], name: "index_levels_on_level_category_id", using: :btree

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
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "word_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "word_categories_words", force: :cascade do |t|
    t.integer  "word_id",          limit: 4
    t.integer  "word_category_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "word_categories_words", ["word_category_id"], name: "index_word_categories_words_on_word_category_id", using: :btree
  add_index "word_categories_words", ["word_id"], name: "index_word_categories_words_on_word_id", using: :btree

  create_table "word_scores", force: :cascade do |t|
    t.integer  "level_instance_id", limit: 4
    t.integer  "word_id",           limit: 4
    t.boolean  "correct"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "word_scores", ["level_instance_id"], name: "index_word_scores_on_level_instance_id", using: :btree
  add_index "word_scores", ["word_id"], name: "index_word_scores_on_word_id", using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "word",          limit: 255
    t.string   "definition_en", limit: 255
    t.string   "definition_fr", limit: 255
    t.string   "gender",        limit: 255
    t.integer  "frequency",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_foreign_key "level_instances", "levels"
  add_foreign_key "level_instances", "users"
  add_foreign_key "level_words", "levels"
  add_foreign_key "level_words", "words"
  add_foreign_key "levels", "level_categories"
  add_foreign_key "word_categories_words", "word_categories"
  add_foreign_key "word_categories_words", "words"
  add_foreign_key "word_scores", "level_instances"
  add_foreign_key "word_scores", "words"
end
