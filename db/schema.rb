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

ActiveRecord::Schema.define(version: 20170906161201) do

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

  create_table "notes", force: :cascade do |t|
    t.text     "note"
    t.text     "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_configurations", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "sound"
    t.boolean  "speak"
    t.boolean  "microphone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_configurations", ["user_id"], name: "index_user_configurations_on_user_id", using: :btree

  create_table "user_words", force: :cascade do |t|
    t.string   "word_text"
    t.string   "examples",       default: [],              array: true
    t.integer  "word_id"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "definition"
    t.text     "example"
    t.string   "source_url"
    t.string   "source_word"
    t.string   "source_example"
    t.string   "type"
  end

  add_index "user_words", ["user_id"], name: "index_user_words_on_user_id", using: :btree
  add_index "user_words", ["word_id"], name: "index_user_words_on_word_id", using: :btree

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "word_frequencies", force: :cascade do |t|
    t.text     "word"
    t.integer  "frequency"
    t.text     "pos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "word_scores", force: :cascade do |t|
    t.integer  "level_instance_id"
    t.integer  "word_id"
    t.integer  "user_id"
    t.integer  "category_id"
    t.boolean  "correct"
    t.boolean  "seen"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "word_scores", ["category_id"], name: "index_word_scores_on_category_id", using: :btree
  add_index "word_scores", ["level_instance_id"], name: "index_word_scores_on_level_instance_id", using: :btree
  add_index "word_scores", ["user_id"], name: "index_word_scores_on_user_id", using: :btree
  add_index "word_scores", ["word_id"], name: "index_word_scores_on_word_id", using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "text"
    t.string   "pos"
    t.boolean  "locution"
    t.jsonb    "definitions"
    t.jsonb    "translations"
    t.jsonb    "semantic_relations"
    t.jsonb    "morphos"
    t.text     "alternative_forms",  default: [],              array: true
    t.string   "gender"
    t.string   "plural"
    t.integer  "frequency"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "Afpfp"
    t.string   "Afpfs"
    t.string   "Afpmp"
    t.string   "Afpms"
    t.string   "Nc?p"
    t.string   "Nc?s"
    t.string   "Ncfp"
    t.string   "Ncfs"
    t.string   "Ncmp"
    t.string   "Ncms"
    t.string   "Npfp"
    t.string   "Npfs"
    t.string   "Npms"
    t.string   "Npmp"
    t.string   "Vmn----"
    t.string   "Vmpp---"
    t.string   "Vmps-pf"
    t.string   "Vmps-pm"
    t.string   "Vmps-sf"
    t.string   "Vmps-sm"
    t.string   "Vmcp1p-"
    t.string   "Vmcp1s-"
    t.string   "Vmcp2p-"
    t.string   "Vmcp2s-"
    t.string   "Vmcp3p-"
    t.string   "Vmcp3s-"
    t.string   "Vmif1p-"
    t.string   "Vmif1s-"
    t.string   "Vmif2p-"
    t.string   "Vmif2s-"
    t.string   "Vmif3p-"
    t.string   "Vmif3s-"
    t.string   "Vmii1p-"
    t.string   "Vmii1s-"
    t.string   "Vmii2p-"
    t.string   "Vmii2s-"
    t.string   "Vmii3p-"
    t.string   "Vmii3s-"
    t.string   "Vmip1p-"
    t.string   "Vmip1s-"
    t.string   "Vmip2p-"
    t.string   "Vmip2s-"
    t.string   "Vmip3p-"
    t.string   "Vmip3s-"
    t.string   "Vmis1p-"
    t.string   "Vmis1s-"
    t.string   "Vmis2p-"
    t.string   "Vmis2s-"
    t.string   "Vmis3p-"
    t.string   "Vmis3s-"
    t.string   "Vmmp1p-"
    t.string   "Vmmp2p-"
    t.string   "Vmmp2s-"
    t.string   "Vmsi1p-"
    t.string   "Vmsi1s-"
    t.string   "Vmsi2p-"
    t.string   "Vmsi2s-"
    t.string   "Vmsi3p-"
    t.string   "Vmsi3s-"
    t.string   "Vmsp1p-"
    t.string   "Vmsp1s-"
    t.string   "Vmsp2p-"
    t.string   "Vmsp2s-"
    t.string   "Vmsp3p-"
    t.string   "Vmsp3s-"
  end

  add_foreign_key "category_words", "categories"
  add_foreign_key "category_words", "words"
  add_foreign_key "level_instances", "levels"
  add_foreign_key "level_instances", "users"
  add_foreign_key "level_words", "levels"
  add_foreign_key "level_words", "words"
  add_foreign_key "levels", "categories"
  add_foreign_key "user_configurations", "users"
  add_foreign_key "user_words", "users"
  add_foreign_key "user_words", "words"
  add_foreign_key "word_scores", "categories"
  add_foreign_key "word_scores", "level_instances"
  add_foreign_key "word_scores", "users"
  add_foreign_key "word_scores", "words"
end
