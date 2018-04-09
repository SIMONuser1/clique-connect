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

ActiveRecord::Schema.define(version: 20180409040331) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "business_skills", force: :cascade do |t|
    t.bigint "business_id"
    t.bigint "skill_id"
    t.boolean "acquired", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_business_skills_on_business_id"
    t.index ["skill_id"], name: "index_business_skills_on_skill_id"
  end

  create_table "businesses", force: :cascade do |t|
    t.string "name"
    t.string "industries"
    t.string "employees"
    t.string "other_partners"
    t.string "other_competitors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clicks", force: :cascade do |t|
    t.bigint "clicker_id"
    t.bigint "clicked_id"
    t.integer "count", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clicked_id"], name: "index_clicks_on_clicked_id"
    t.index ["clicker_id"], name: "index_clicks_on_clicker_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.bigint "business_id"
    t.bigint "competitor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_competitions_on_business_id"
    t.index ["competitor_id"], name: "index_competitions_on_competitor_id"
  end

  create_table "partnerships", force: :cascade do |t|
    t.bigint "business_id"
    t.bigint "partner_id"
    t.boolean "acquired", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_partnerships_on_business_id"
    t.index ["partner_id"], name: "index_partnerships_on_partner_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suggestions", force: :cascade do |t|
    t.bigint "business_id"
    t.bigint "suggested_business_id"
    t.integer "rating", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_suggestions_on_business_id"
    t.index ["suggested_business_id"], name: "index_suggestions_on_suggested_business_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.bigint "business_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_users_on_business_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "business_skills", "businesses"
  add_foreign_key "business_skills", "skills"
  add_foreign_key "clicks", "businesses", column: "clicked_id"
  add_foreign_key "clicks", "businesses", column: "clicker_id"
  add_foreign_key "competitions", "businesses"
  add_foreign_key "competitions", "businesses", column: "competitor_id"
  add_foreign_key "partnerships", "businesses"
  add_foreign_key "partnerships", "businesses", column: "partner_id"
  add_foreign_key "suggestions", "businesses"
  add_foreign_key "suggestions", "businesses", column: "suggested_business_id"
  add_foreign_key "users", "businesses"
end
